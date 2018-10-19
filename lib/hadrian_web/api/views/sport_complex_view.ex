defmodule HadrianWeb.Api.SportComplexView do
  use HadrianWeb, :view
  
  alias HadrianWeb.Api.SportComplexView
  alias HadrianWeb.Api.ErrorView

  def render("index.json", %{sport_complexs: sport_complexs}) do
    %{
      status: :ok,
      data: %{
        sport_complexes: render_many(sport_complexs, SportComplexView, "sport_complex.json")
      }
    }
  end

  def render("show.json", %{sport_complex: sport_complex}) do
    %{
      status: :ok,
      data: %{
        sport_complex: render_one(sport_complex, SportComplexView, "sport_complex.json")
      }
    }
  end

  def render("sport_complex.json", %{sport_complex: sport_complex}) do
    %{id: sport_complex.id, 
      name: sport_complex.name}
  end

  def render("ok.delete.json", %{sport_complex: sport_complex}) do
    %{status: :ok,
      data: render("sport_complex.json", sport_complex: sport_complex)}
  end

  def render("error.delete.json", %{changeset: changeset}) do
    errors = ErrorView.parse_errors(changeset)

    %{}
    |> Map.put(:errors, errors)
    |> Map.put(:status, :error)
  end
  
  def render("error.delete.json", %{sport_complex_id: incorrect_id}) do
    error = %{"id" => ["No such sport complex with id #{incorrect_id}"]}
    
    %{status: :error}
    |> Map.put(:errors, error)
  end 
end