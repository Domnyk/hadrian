defmodule HadrianWeb.Api.ParticipationView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.ParticipationView

  def render("index.json", %{participations: participations}) do
    %{participations: render_many(participations, ParticipationView, "show.json")}
  end

  def render("show.json", %{participation: participation}) do
    %{
      event_id: participation.event_id,
      user_id: participation.user_id,
      is_event_owner: participation.is_event_owner,
      has_paid: participation.has_paid
    }
  end
end
