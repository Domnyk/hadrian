defmodule HadrianWeb.Api.SportComplexView do
  use HadrianWeb, :view
  
  alias HadrianWeb.Api.SportComplexView

  def render("index.json", %{sport_complexs: sport_complexs}) do
    %{status: :ok,
      data: render_many(sport_complexs, SportComplexView, "sport_complex.json")}
  end

  def render("sport_complex.json", %{sport_complex: sport_complex}) do
    %{id: sport_complex.id, 
      name: sport_complex.name}
  end
end