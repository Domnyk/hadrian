defmodule HadrianWeb.Api.ExternalEventView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.ExternalEventView

  @moduledoc false

  def render("index.json", %{external_events: external_events}) do
    render_many(external_events, ExternalEventView, "external_event.json")
  end

  def render("show.json", %{external_event: external_event}) do
    render_one(external_event, ExternalEventView, "external_event.json")
  end

  def render("external_event.json", %{external_event: external_event}) do
    %{id: external_event.id,
      event_day: external_event.event_day,
      start_time: external_event.start_time,
      end_time: external_event.end_time,
      sport_arena_id: external_event.sport_arena_id}
  end
end
