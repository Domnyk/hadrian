defmodule Hadrian.Session do
  alias Hadrian.Repo
  alias Hadrian.Accounts.User
  alias Hadrian.Session.InApp
  alias Hadrian.Session.Facebook
  
  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id do
      Hadrian.Repo.get(User, id)
    end
  end

  def login(conn, source) do
    source |> inspect |> IO.puts

    case source do
      :in_app -> InApp.login(conn)
      :facebook -> Facebook.login(conn)
      _ -> :error
    end
  end

  def logged_in?(conn) do
    !!current_user(conn)
  end
end