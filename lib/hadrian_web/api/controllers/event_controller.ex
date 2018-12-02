defmodule HadrianWeb.Api.EventController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Activities
  alias Hadrian.Activities.Event

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_arena_id" => sport_arena_id}) when is_binary(sport_arena_id) do
    {id, _} = Integer.parse(sport_arena_id)
    events = Activities.list_events(id)
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"sport_arena_id" => sport_arena_id, "event" => event_params}) do
    params = event_params
    |> Map.put("sport_arena_id", sport_arena_id)
    |> Map.put("users", [get_session(conn, :current_user_id)])

    with {:ok, %Event{} = event} <- Activities.create_event(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", sport_arena_event_path(conn, :show, sport_arena_id, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Activities.get_event!(id)
    render(conn, "show.json", event: event)
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
