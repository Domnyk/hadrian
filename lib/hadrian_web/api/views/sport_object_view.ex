defmodule HadrianWeb.Api.SportObjectView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.SportObjectView
  alias HadrianWeb.Api.SportArenaView

  def render("index.json", %{sport_objects: sport_objects}) do
    %{
      status: :ok,
      data: %{
        sport_objects: render_many(sport_objects, SportObjectView, "sport_object.json")
      }
    }
  end

  def render("show.json", %{sport_object: sport_object}) do
    %{
      status: :ok,
      data: %{
        sport_object: render_one(sport_object, SportObjectView, "sport_object.json")
      }
    }
  end

  def render("sport_object.json", %{sport_object: sport_object}) do
    resp = %{
      id: sport_object.id,
      geo_coordinates: sport_object.geo_coordinates,
      address: sport_object.address,
      name: sport_object.name,
      booking_margin: sport_object.booking_margin,
      sport_complex_id: sport_object.sport_complex_id
    }

    case Ecto.assoc_loaded?(sport_object.sport_arenas) do
      true ->
        Map.put(resp, :sport_arenas, render_many(sport_object.sport_arenas, SportArenaView, "sport_arena.json"))
      false -> resp
    end
  end

  def render("index.basic.json", %{sport_objects: sport_objects}) do
    %{
      status: :ok,
      data: %{
        sport_objects: render_many(sport_objects, SportObjectView, "sport_object.basic.json")
      }
    }
  end

  def render("sport_object.basic.json", %{sport_object: sport_object}) do
    %{id: sport_object.id, 
      name: sport_object.name}
  end

  def render("search.json", %{results: results, params: params}) do
    %{results: render_many(results, SportObjectView, "result.json", as: :result),
      params: params}
  end

  def render("result.json", %{result: %{object_id: id, average_price: avg_price, distance: dist}}) do
    %{object_id: id, average_price: avg_price, distance: dist}
  end
end