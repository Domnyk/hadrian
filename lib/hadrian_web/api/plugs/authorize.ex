defmodule HadrianWeb.Api.Plugs.Authorize do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    current_user_id =
      conn
      |> get_session(:current_user_id)

    case current_user_id do
      nil -> handle_unauthorized(conn)
      _ -> conn
    end
  end

  defp handle_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(HadrianWeb.Api.ErrorView, :"401")
    |> halt()
  end
end
