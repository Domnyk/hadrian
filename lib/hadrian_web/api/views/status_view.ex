defmodule HadrianWeb.Api.StatusView do
  use HadrianWeb, :view

  def render("index.json", %{}) do
    "online"
  end
end
