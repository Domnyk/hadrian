defmodule HadrianWeb.Api.EventView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.EventView
  alias HadrianWeb.Api.UserView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      name: event.name,
      max_num_of_participants: event.max_num_of_participants,
      min_num_of_participants: event.min_num_of_participants,
      event_day: event.event_day,
      end_of_joining_phase: event.end_of_joining_phase,
      end_of_paying_phase: event.end_of_paying_phase,
      start_time: event.start_time,
      end_time: event.end_time,
      participators: render_many(event.participators, UserView, "id.json")
    }
  end
end
