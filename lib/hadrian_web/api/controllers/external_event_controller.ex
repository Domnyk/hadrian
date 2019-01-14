defmodule HadrianWeb.Api.ExternalEventController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Activities
  alias Hadrian.Activities.ExternalEvent

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
    external_event = Activities.get_external_event!(id)

    with {:ok, %ExternalEvent{} = external_event} <- Activities.update_external_event(external_event, attrs) do
      render(conn, "show.json", external_event: external_event)
    end
  end

  def delete(conn, %{"id" => id}) do
    external_event = Activities.get_external_event!(id)
    with {:ok, %ExternalEvent{}} <- Activities.delete_external_event(external_event) do
      send_resp(conn, :no_content, "")
    end
  end

end
