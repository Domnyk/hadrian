defmodule HadrianWeb.SportArenaController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena

  def index(conn, _params) do
    sport_arenas = Owners.list_sport_arenas()
    render(conn, "index.html", sport_arenas: sport_arenas)
  end

  def new(conn, _params) do
    changeset = Owners.change_sport_arena(%SportArena{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sport_arena" => sport_arena_params}) do
    case Owners.create_sport_arena(sport_arena_params) do
      {:ok, sport_arena} ->
        conn
        |> put_flash(:info, "Sport arena created successfully.")
        |> redirect(to: sport_arena_path(conn, :show, sport_arena))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sport_arena = Owners.get_sport_arena!(id)
    render(conn, "show.html", sport_arena: sport_arena)
  end

  def edit(conn, %{"id" => id}) do
    sport_arena = Owners.get_sport_arena!(id)
    changeset = Owners.change_sport_arena(sport_arena)
    render(conn, "edit.html", sport_arena: sport_arena, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sport_arena" => sport_arena_params}) do
    sport_arena = Owners.get_sport_arena!(id)

    case Owners.update_sport_arena(sport_arena, sport_arena_params) do
      {:ok, sport_arena} ->
        conn
        |> put_flash(:info, "Sport arena updated successfully.")
        |> redirect(to: sport_arena_path(conn, :show, sport_arena))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sport_arena: sport_arena, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sport_arena = Owners.get_sport_arena!(id)
    {:ok, _sport_arena} = Owners.delete_sport_arena(sport_arena)

    conn
    |> put_flash(:info, "Sport arena deleted successfully.")
    |> redirect(to: sport_arena_path(conn, :index))
  end
end
