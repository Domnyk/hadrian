defmodule HadrianWeb.Api.EventController do
  use HadrianWeb, :controller

  alias Hadrian.Activities
  alias Hadrian.Activities.Event

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, _params) do
    events = Activities.list_events()
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Activities.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", event_path(conn, :show, event))
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
