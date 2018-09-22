defmodule HadrianWeb.Api.SportComplexController do
  use HadrianWeb, :controller

  alias Hadrian.Owners

  def index(conn, _params) do
    sport_complexs = Owners.list_sport_complexes

    render(conn, "index.json", sport_complexs: sport_complexs)
  end

  def create(conn, params) do
    case Owners.create_sport_complex(params) do
      {:ok, sport_complex} -> render(conn, "ok.create.json", sport_complex: sport_complex)
      {:error, changeset} -> render(conn, "error.create.json", changeset: changeset)
    end
  end 
end