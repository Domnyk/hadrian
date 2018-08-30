defmodule HadrianWeb.Api.SessionView do
  use HadrianWeb, :view

  def render("ok.create.json", _params) do
    %{status: :ok, message: "YAY!"}
  end

  def render("error.create.json", %{reason: reason}) do
    %{status: :error, reason: reason}
  end
end