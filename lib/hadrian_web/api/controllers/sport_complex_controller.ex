defmodule HadrianWeb.Api.SportComplexController do
  use HadrianWeb, :controller

  alias Hadrian.Owners

  def index(conn, _params) do
    sport_complexs = Owners.list_sport_complexes

    render(conn, "index.json", sport_complexs: sport_complexs)
  end
end