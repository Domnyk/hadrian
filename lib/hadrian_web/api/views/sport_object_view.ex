defmodule HadrianWeb.Api.SportObjectView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.SportObjectView
  alias HadrianWeb.ErrorView

  def render("index.json", %{sport_objects: sport_objects}) do
    %{
      status: :ok,
      data: %{
        sport_objects: render_many(sport_objects, SportObjectView, "sport_object.json")
      }
    }
  end

  def render("sport_object.json", %{sport_object: sport_object}) do
    %{id: sport_object.id, 
      geo_coordinates: sport_object.geo_coordinates, 
      name: sport_object.name,
      booking_margin: sport_object.booking_margin}
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

  def render("ok.create.json", %{sport_object: sport_object}) do
    sport_object = %{
      id: sport_object.id, 
      geo_coordinates: sport_object.geo_coordinates, 
      name: sport_object.name,
      booking_margin: sport_object.booking_margin,
      sport_complex_id: sport_object.sport_complex_id
    }

    %{status: :ok,
      data: %{
        sport_object: sport_object
      }
    }
  end

  def render("error.create.json", %{changeset: changeset}) do
    errors = ErrorView.parse_errors(changeset)

    %{}
    |> Map.put(:errors, errors)
    |> Map.put(:status, :error)
  end

end