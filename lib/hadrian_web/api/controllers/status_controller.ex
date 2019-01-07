defmodule HadrianWeb.Api.StatusController do
  use HadrianWeb, :controller

  def index(conn, _attrs) do
    render(conn, "index.json")
  end

end
