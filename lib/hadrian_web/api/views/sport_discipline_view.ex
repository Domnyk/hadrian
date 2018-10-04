defmodule HadrianWeb.Api.SportDisciplineView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.SportDisciplineView

  def render("index.json", %{sport_disciplines: sport_disciplines}) do
    %{
      status: :ok,
      data: %{
        sport_disciplines: render_many(sport_disciplines, SportDisciplineView, "sport_discipline.json")
      }
    }
  end

  def render("sport_discipline.json", %{sport_discipline: sport_discipline}) do
    %{
      id: sport_discipline.id,
      name: sport_discipline.name
    }
  end
end
