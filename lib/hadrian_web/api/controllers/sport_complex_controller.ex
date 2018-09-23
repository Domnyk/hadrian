defmodule HadrianWeb.Api.SportComplexController do
  use HadrianWeb, :controller

  alias Ecto.Changeset
  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex

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
  
  def delete(conn, %{"id" => id}) do
    case Owners.delete_sport_complex(id) do
      {:ok, %SportComplex{} = sport_complex} -> render(conn, "ok.delete.json", sport_complex: sport_complex)
      {:error, :no_such_sport_complex} -> render(conn, "error.delete.json", sport_complex_id: id)
      {:error, %Changeset{} = changeset} -> render(conn, "error.delete.json", changeset: changeset)
    end
  end
end