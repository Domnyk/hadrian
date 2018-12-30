defmodule HadrianWeb.Api.SportObjectController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_complex_id" => sport_complex_id}) do
    sport_objects = Owners.list_sport_objects(sport_complex_id)

    render(conn, "index.json", sport_objects: sport_objects)
  end

  def index(conn, _params) do
    sport_objects = Owners.list_sport_objects(:with_arenas)

    render(conn, "index.json", sport_objects: sport_objects)
  end

  def show(conn, %{"id" => id}) do
    try do
      sport_object = Owners.get_sport_object!(id, :with_sport_arenas_and_disciplines)

      render(conn, "show.json", sport_object: sport_object)
    rescue
      Ecto.NoResultsError -> HadrianWeb.Api.FallbackController.call(conn, {:error, :not_found})
    end
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

  def search(conn, attrs) do
    %{"day" => day_string, "disciplines" => disciplines, "geo_location" => %{"lat" => lat, "lng" => lng}} = attrs;
    criteria = %{day: Date.from_iso8601!(day_string), disciplines: disciplines, geo_location: {lat, lng}}

    with results when is_list(results) <- Owners.search_for_objects(criteria) do
      render(conn, "search.json", results: results, params: attrs)
    end
  end
end