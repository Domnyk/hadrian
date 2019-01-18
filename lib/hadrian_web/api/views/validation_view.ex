defmodule HadrianWeb.Api.ValidationView do
  use HadrianWeb, :view

  def render("valid.json", _) do
    %{valid: true}
  end

  def render("invalid.json", _) do
    %{valid: false}
  end

end
