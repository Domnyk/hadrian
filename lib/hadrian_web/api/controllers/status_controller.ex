defmodule HadrianWeb.Api.StatusController do
  @doc """
    Using Phoenix.Controller directly to disable any logs on this controller.
  """
  use Phoenix.Controller, namespace: HadrianWeb, log: false

  def index(conn, _attrs) do
    render(conn, "index.json")
  end
end
