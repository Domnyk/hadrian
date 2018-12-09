defmodule HadrianWeb.Api.ParticipatorView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.ParticipatorView
  alias HadrianWeb.Api.ErrorView

  def render("index.json", %{participators: participators}) do
    %{data: render_many(participators, ParticipatorView, "show.json")}
  end

  def render("show.json", %{event: event}) do
    %{
      event: %{
        id: event.id
      }
    }
  end
end
