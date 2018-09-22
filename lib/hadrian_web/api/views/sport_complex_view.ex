defmodule HadrianWeb.Api.SportComplexView do
  use HadrianWeb, :view
  
  alias HadrianWeb.Api.SportComplexView
  alias HadrianWeb.ErrorView

  def render("index.json", %{sport_complexs: sport_complexs}) do
    %{status: :ok,
      data: render_many(sport_complexs, SportComplexView, "sport_complex.json")}
  end

  def render("sport_complex.json", %{sport_complex: sport_complex}) do
    %{id: sport_complex.id, 
      name: sport_complex.name}
  end

  def render("ok.create.json", %{sport_complex: sport_complex}) do
    %{status: :ok,
      data: render("sport_complex.json", sport_complex: sport_complex)}
  end

  def render("error.create.json", %{changeset: changeset}) do
    errors = ErrorView.parse_errors(changeset)

    %{}
    |> Map.put(:errors, errors)
    |> Map.put(:status, :error)
  end
end