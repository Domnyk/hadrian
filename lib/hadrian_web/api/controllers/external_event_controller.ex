defmodule HadrianWeb.Api.ExternalEventController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Activities
  alias Hadrian.Owners
  alias Hadrian.Activities.ExternalEvent
  alias HadrianWeb.Api.Helpers.Session

  action_fallback HadrianWeb.Api.FallbackController

  plug HadrianWeb.Api.Plugs.AuthorizeOwner when action in [:create, :update, :delete]

  def index(conn, %{"sport_arena_id" => sport_arena_id}) when is_binary(sport_arena_id) do
    {id, _} = Integer.parse(sport_arena_id)
    render(conn, "index.json", external_events: Activities.list_external_events(id))
  end

  def create(conn, attrs) do
    with {:ok, %ExternalEvent{} = external_event} <- Activities.create_external_event(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", external_event_path(conn, :show, external_event.id))
      |> render("show.json", external_event: external_event)
    end
  end

  def show(conn, %{"id" => id}) do
    external_event = Activities.get_external_event!(id)
    render(conn, "show.json", external_event: external_event)
  end

  def update(conn, %{"id" => id} = attrs) do
    with {:ok, %ExternalEvent{} = external_event} <- Activities.get_external_event(id),
         {:ok, _} <- authorize_owner(conn, id),
         {:ok, %ExternalEvent{} = external_event} <- Activities.update_external_event(external_event, attrs) do
      render(conn, "show.json", external_event: external_event)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %ExternalEvent{} = external_event} <- Activities.get_external_event(id),
         {:ok, _} <- authorize_owner(conn, id),
         {:ok, %ExternalEvent{}} <- Activities.delete_external_event(external_event) do
      send_resp(conn, :no_content, "")
    end
  end

  defp authorize_owner(conn, external_event_id) do
    owner_id = external_event_id
    |> Activities.get_external_event!()
    |> Map.get(:sport_arena_id)
    |> Owners.get_sport_arena!()
    |> Map.get(:sport_object_id)
    |> Owners.get_sport_object!()
    |> Map.get(:sport_complex_id)
    |> Owners.get_sport_complex!()
    |> Map.get(:complexes_owner_id)

    owner_id_from_session = Session.get_user_id(conn)

    case owner_id == owner_id_from_session do
      true -> {:ok, :match}
      false -> {:error, :owner_mismatch}
    end
  end

end
