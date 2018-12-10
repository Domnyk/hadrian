defmodule HadrianWeb.Api.EventController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Activities
  alias Hadrian.Activities.Event
  alias Hadrian.Activities.Participation

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_arena_id" => sport_arena_id}) when is_binary(sport_arena_id) do
    {id, _} = Integer.parse(sport_arena_id)
    events = Activities.list_events(id)
    events_with_participations = Enum.map(events, fn event -> {event, Activities.list_participations(event.id)} end)
    render(conn, "index.json", events_with_participations: events_with_participations)
  end

  def create(conn, %{"sport_arena_id" => sport_arena_id, "event" => event_params}) do
    params = Map.put(event_params, "sport_arena_id", sport_arena_id)
    event_owner = Accounts.get_user!(get_session(conn, :current_user_id))

    with {:ok, %Event{} = event} <- Activities.create_event(params),
         {:ok, %Participation{}} <- Activities.create_participation(event, event_owner, true)
    do
      participations = Activities.list_participations(event.id)
      event = Activities.get_event!(event.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", sport_arena_event_path(conn, :show, sport_arena_id, event))
      |> render("event.json", event: event, participations: participations)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Activities.get_event!(id)
    participations = Activities.list_participations(id)
    render(conn, "event.json", event: event, participations: participations)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Activities.get_event!(id)

    with {:ok, %Event{} = event} <- Activities.update_event(event, event_params) do
      participations = Activities.list_participations(id)
      render(conn, "event.json", event: event, participations: participations)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Activities.get_event!(id)
    with {:ok, %Event{}} <- Activities.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
