defmodule HadrianWeb.Api.SportArenaView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.SportArenaView
  alias HadrianWeb.Api.SportDisciplineView

  def render("index.json", %{sport_arenas: sport_arenas}) do
    %{
      status: :ok,
      data: %{
        sport_arenas: render_many(sport_arenas, SportArenaView, "sport_arena.json")
      }
    }
  end

  def render("show.json", %{sport_arena: sport_arena}) do
    %{
      status: :ok,
      data: %{
        sport_arena: render_one(sport_arena, SportArenaView, "sport_arena.json")
      }
    }
  end

  def render("sport_arena.json", %{sport_arena: sport_arena}) do
    sport_disciplines = sport_arena.sport_disciplines

    %{
      id: sport_arena.id,
      name: sport_arena.name,
      sport_disciplines: render_many(sport_disciplines, SportDisciplineView, "sport_discipline.json"),
      sport_object_id: sport_arena.sport_object_id
    }
  end
end
