defmodule HadrianWeb.SportComplexController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex

  def index(conn, _params) do
    sport_complexes = Owners.list_sport_complexes()
    render(conn, "index.html", sport_complexes: sport_complexes)
  end

  def new(conn, _params) do
    changeset = Owners.change_sport_complex(%SportComplex{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sport_complex" => sport_complex_params}) do
    case Owners.create_sport_complex(sport_complex_params) do
      {:ok, sport_complex} ->
        conn
        |> put_flash(:info, "Sport complex created successfully.")
        |> redirect(to: sport_complex_path(conn, :show, sport_complex))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sport_complex = Owners.get_sport_complex!(id)
    render(conn, "show.html", sport_complex: sport_complex)
  end

  def edit(conn, %{"id" => id}) do
    sport_complex = Owners.get_sport_complex!(id)
    changeset = Owners.change_sport_complex(sport_complex)
    render(conn, "edit.html", sport_complex: sport_complex, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sport_complex" => sport_complex_params}) do
    sport_complex = Owners.get_sport_complex!(id)

    case Owners.update_sport_complex(sport_complex, sport_complex_params) do
      {:ok, sport_complex} ->
        conn
        |> put_flash(:info, "Sport complex updated successfully.")
        |> redirect(to: sport_complex_path(conn, :show, sport_complex))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sport_complex: sport_complex, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sport_complex = Owners.get_sport_complex!(id)
    {:ok, _sport_complex} = Owners.delete_sport_complex(sport_complex)

    conn
    |> put_flash(:info, "Sport complex deleted successfully.")
    |> redirect(to: sport_complex_path(conn, :index))
  end
end
