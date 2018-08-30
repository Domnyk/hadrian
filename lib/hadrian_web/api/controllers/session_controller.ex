defmodule HadrianWeb.Api.SessionController do
  use HadrianWeb, :controller

  def create(conn, %{"authServiceName" => authServiceName} = params) do
    render(conn, "ok.create.json")
  end

  def create(conn, _params) do
    render(conn, "error.create.json", reason: "No authorization service name provided")
  end
end