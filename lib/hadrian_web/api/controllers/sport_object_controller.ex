defmodule HadrianWeb.Api.SportObjectController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject
  alias Ecto.Changeset

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_complex_id" => sport_complex_id}) do
    sport_objects = Owners.list_sport_objects(sport_complex_id)

    render(conn, "index.json", sport_objects: sport_objects)
  end

  def create(conn, %{"data" => %{"sport_object" => sport_object_params}}) do
    with {:ok, %SportObject{} = sport_object} <- Owners.create_sport_object(sport_object_params) do
      conn
      |> put_status(:created)
      |> render("show.json", sport_object: sport_object)
    end
  end

  def update(conn, %{"data" => %{"sport_object" => sport_object_params}, "id" => id}) do
    sport_object = Owners.get_sport_object!(id)

    with {:ok, %SportObject{} = sport_object} <- Owners.update_sport_object(sport_object, sport_object_params) do
      render(conn, "show.json", sport_object: sport_object)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %SportObject{}} <- Owners.delete_sport_object(id) do
      send_resp(conn, :no_content, "")
    end
  end
end