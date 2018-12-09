defmodule HadrianWeb.Api.EventController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Activities
  alias Hadrian.Activities.Event
  alias Hadrian.Activities.Participator

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_arena_id" => sport_arena_id}) when is_binary(sport_arena_id) do
    {id, _} = Integer.parse(sport_arena_id)
    events = Activities.list_events(id)
    events_with_participators = Enum.map(events, fn event -> {event, Activities.list_participators(event.id)} end)
    render(conn, "index.json", events_with_participators: events_with_participators)
  end

  def create(conn, %{"sport_arena_id" => sport_arena_id, "event" => event_params}) do
    params = Map.put(event_params, "sport_arena_id", sport_arena_id)
    event_owner = Accounts.get_user!(get_session(conn, :current_user_id))

    with {:ok, %Event{} = event} <- Activities.create_event(params),
         {:ok, %Participator{}} <- Activities.create_participator(event, event_owner, true)
    do
      conn
      |> put_status(:created)
      |> put_resp_header("location", sport_arena_event_path(conn, :show, sport_arena_id, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Activities.get_event!(id)
    participators = Activities.list_participators(id)
    render(conn, "event.json", event: event, participators: participators)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Activities.get_event!(id)

    with {:ok, %Event{} = event} <- Activities.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Activities.get_event!(id)
    with {:ok, %Event{}} <- Activities.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
