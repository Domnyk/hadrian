defmodule HadrianWeb.Api.ParticipatorView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.ParticipatorView

  def render("index.json", %{participators: participators}) do
    %{participators: render_many(participators, ParticipatorView, "show.json")}
  end

  def render("show.json", %{participator: participator}) do
    %{
      event_id: participator.event_id,
      user_id: participator.user_id,
      is_event_owner: participator.is_event_owner,
      has_paid: participator.has_paid
    }
  end
end
