defmodule HadrianWeb.RootController do
  use HadrianWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
