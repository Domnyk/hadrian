defmodule HadrianWeb.Api.SportObjectView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.SportObjectView

  def render("index.json", %{sport_objects: sport_objects}) do
    render_many(sport_objects, SportObjectView, "sport_object.json")
  end

  def render("sport_object.json", %{sport_object: sport_object}) do
    %{id: sport_object.id, 
      geo_coordinates: sport_object.geo_coordinates, 
      name: sport_object.name,
      booking_margin: sport_object.booking_margin}
  end
end