defmodule HadrianWeb.Api.Helpers.Session do
  import Plug.Conn

  def get_user_id(%Plug.Conn{} = conn) do
    conn
    |> fetch_session()
    |> get_session(:current_user_id)
  end

  def get_user_type(%Plug.Conn{} = conn) do
    conn
    |> fetch_session()
    |> get_session(:current_user_type)
  end
end
