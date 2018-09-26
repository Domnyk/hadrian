defmodule HadrianWeb.Api.SportObjectController do
  use HadrianWeb, :controller

  alias Hadrian.Owners

  def index(conn, _params) do
    sport_objects = Owners.list_sport_objects

    render(conn, "index.json", sport_objects: sport_objects)
  end

  def create(conn, %{"data" => %{"sport_object" => sport_object_params}}) do
  end
end