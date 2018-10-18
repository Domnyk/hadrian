defmodule HadrianWeb.Api.SportComplexController do
  use HadrianWeb, :controller

  alias Ecto.Changeset
  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, _params) do
    sport_complexs = Owners.list_sport_complexes

    render(conn, "index.json", sport_complexs: sport_complexs)
  end

  def create(conn, %{"data" => %{"sport_complex" => sport_complex_params}}) do
    with {:ok, %SportComplex{} = sport_complex} <- Owners.create_sport_complex(sport_complex_params) do
      conn
      |> put_status(:created)
      |> render("show.json", sport_complex: sport_complex)
    end
  end

  def update(conn, %{"data" => %{"sport_complex" => sport_complex_params}, "id" => id}) do
    sport_complex = Owners.get_sport_complex!(id)

    with {:ok, %SportComplex{} = sport_complex} <- Owners.update_sport_complex(sport_complex, sport_complex_params) do
      render(conn, "show.json", sport_complex: sport_complex)
    end
  end
  
  def delete(conn, %{"id" => id}) do
    with {:ok, %SportComplex{}} <- Owners.delete_sport_complex(id) do
      send_resp(conn, :no_content, "")
    end
  end
end