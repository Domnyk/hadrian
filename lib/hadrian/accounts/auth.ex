defmodule Hadrian.Auth do
	alias Hadrian.Accounts

	def user_logged?(conn) do
    !!Plug.Conn.get_session(conn, :logged_user_id)
  end

  def get_current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :logged_user_id)

    Accounts.get_user!(user_id)
  end
end