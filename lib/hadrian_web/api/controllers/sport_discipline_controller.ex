defmodule HadrianWeb.Api.SportDisciplineController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportDiscipline

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, _params) do
    sport_disciplines = Owners.list_sport_disciplines()
    render(conn, "index.json", sport_disciplines: sport_disciplines)
  end
end
