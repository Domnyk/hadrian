defmodule HadrianWeb.SportObjectController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject

  def index(conn, _params) do
    sport_objects = Owners.list_sport_objects()
    render(conn, "index.html", sport_objects: sport_objects)
  end

  def new(conn, _params) do
    changeset = Owners.change_sport_object(%SportObject{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sport_object" => sport_object_params}) do
    case Owners.create_sport_object(sport_object_params) do
      {:ok, sport_object} ->
        conn
        |> put_flash(:info, "Sport object created successfully.")
        |> redirect(to: sport_object_path(conn, :show, sport_object))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sport_object = Owners.get_sport_object!(id)
    render(conn, "show.html", sport_object: sport_object)
  end

  def edit(conn, %{"id" => id}) do
    sport_object = Owners.get_sport_object!(id)
    changeset = Owners.change_sport_object(sport_object)
    render(conn, "edit.html", sport_object: sport_object, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sport_object" => sport_object_params}) do
    sport_object = Owners.get_sport_object!(id)

    case Owners.update_sport_object(sport_object, sport_object_params) do
      {:ok, sport_object} ->
        conn
        |> put_flash(:info, "Sport object updated successfully.")
        |> redirect(to: sport_object_path(conn, :show, sport_object))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sport_object: sport_object, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sport_object = Owners.get_sport_object!(id)
    {:ok, _sport_object} = Owners.delete_sport_object(sport_object)

    conn
    |> put_flash(:info, "Sport object deleted successfully.")
    |> redirect(to: sport_object_path(conn, :index))
  end
end
