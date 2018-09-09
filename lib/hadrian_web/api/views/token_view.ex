defmodule HadrianWeb.Api.TokenView do
  use HadrianWeb, :view

  def render("request.json", _params) do
    %{status: :ok}
  end

  def render("error.callback.json", _params) do
    %{status: :error}
  end
  
  def render("ok.callback.json", %{jwt: jwt}) do
    %{status: :ok, jwt: jwt}
  end

  def render("ok.create.json", %{jwt: jwt}) do
    %{status: :ok, jwt: jwt}
  end

  def render("error.create.json", %{reason: reason}) do
    %{status: :error, reason: reason}
  end
end