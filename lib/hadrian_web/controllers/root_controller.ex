defmodule HadrianWeb.RootController do
  use HadrianWeb, :controller

  def index(conn, _params) do
    conn |> inspect |> IO.puts
    
    render conn, "index.html"
  end
end
