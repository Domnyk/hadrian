defmodule HadrianWeb.Api.Plugs.Authenticate do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    current_user_id =
      conn
      |> fetch_session
      |> get_session(:current_user_id)

    case current_user_id do
      nil -> handle_unauthorized(conn)
      _ -> conn
    end
  end

  defp handle_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.redirect(external: get_origin(conn))
  end

  defp get_origin(conn) do
    conn.req_headers |> inspect |> IO.puts

    "http://example.com"
  end
end
