defmodule HadrianWeb.Api.FallbackController do
  require Logger

  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use HadrianWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    Logger.warn inspect(changeset)

    conn
    |> put_status(:unprocessable_entity)
    |> render(HadrianWeb.Api.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(HadrianWeb.Api.ErrorView, :"404")
  end
end
