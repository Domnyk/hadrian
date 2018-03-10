defmodule HadrianWeb.SportsDisciplineController do
  use HadrianWeb, :controller

  alias Hadrian.SportsVenue
  alias Hadrian.SportsVenue.SportsDiscipline

  def index(conn, _params) do
    sports_disciplines = SportsVenue.list_sports_disciplines()
    render(conn, "index.html", sports_disciplines: sports_disciplines)
  end

  def new(conn, _params) do
    changeset = SportsVenue.change_sports_discipline(%SportsDiscipline{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sports_discipline" => sports_discipline_params}) do
    case SportsVenue.create_sports_discipline(sports_discipline_params) do
      {:ok, sports_discipline} ->
        conn
        |> put_flash(:info, "Sports discipline created successfully.")
        |> redirect(to: sports_discipline_path(conn, :show, sports_discipline))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sports_discipline = SportsVenue.get_sports_discipline!(id)
    render(conn, "show.html", sports_discipline: sports_discipline)
  end

  def edit(conn, %{"id" => id}) do
    sports_discipline = SportsVenue.get_sports_discipline!(id)
    changeset = SportsVenue.change_sports_discipline(sports_discipline)
    render(conn, "edit.html", sports_discipline: sports_discipline, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sports_discipline" => sports_discipline_params}) do
    sports_discipline = SportsVenue.get_sports_discipline!(id)

    case SportsVenue.update_sports_discipline(sports_discipline, sports_discipline_params) do
      {:ok, sports_discipline} ->
        conn
        |> put_flash(:info, "Sports discipline updated successfully.")
        |> redirect(to: sports_discipline_path(conn, :show, sports_discipline))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sports_discipline: sports_discipline, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sports_discipline = SportsVenue.get_sports_discipline!(id)
    {:ok, _sports_discipline} = SportsVenue.delete_sports_discipline(sports_discipline)

    conn
    |> put_flash(:info, "Sports discipline deleted successfully.")
    |> redirect(to: sports_discipline_path(conn, :index))
  end
end
