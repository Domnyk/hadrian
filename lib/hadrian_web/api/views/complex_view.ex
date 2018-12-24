defmodule HadrianWeb.Api.ComplexView do
  use HadrianWeb, :view
  
  alias HadrianWeb.Api.ComplexView

  def render("index.json", %{complexes: complexes}) do
    render_many(complexes, ComplexView, "show.json")
  end

  def render("show.json", %{complex: complex}) do
    %{id: complex.id, name: complex.name}
  end
end