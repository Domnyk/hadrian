defmodule HadrianWeb.Api.Plugs.AuthorizeOwner do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    current_user_type =
      conn
      |> get_session(:current_user_type)

    case current_user_type do
      :owner -> conn
      _ -> handle_unauthorized(conn)
    end
  end

  defp handle_unauthorized(conn) do
    message = "You must be signed in as owner to perform this action"

    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(HadrianWeb.Api.ErrorView, :"401", message: message)
    |> halt()
  end

end
