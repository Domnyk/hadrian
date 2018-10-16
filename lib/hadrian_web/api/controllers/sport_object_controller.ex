defmodule HadrianWeb.Api.SportObjectController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject
  alias Ecto.Changeset

  def index(conn, %{"sport_complex_id" => sport_complex_id}) do
    sport_objects = Owners.list_sport_objects(sport_complex_id)

    render(conn, "index.json", sport_objects: sport_objects)
  end

  def create(conn, %{"data" => %{"sport_object" => sport_object_params}}) do  
    case Owners.create_sport_object(sport_object_params) do
      {:ok, %SportObject{} = sport_object} -> render(conn, "ok.create.json", sport_object: sport_object)
      {:error, %Changeset{} = changeset} -> render(conn, "error.create.json", changeset: changeset)
    end
  end
end