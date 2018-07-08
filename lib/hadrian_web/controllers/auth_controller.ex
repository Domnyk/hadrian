defmodule HadrianWeb.AuthController do
  use HadrianWeb, :controller

  # import Plug.Conn
  alias Hadrian.Accounts
  require Logger

  plug Ueberauth

  def login(conn, _params) do
    conn
    |> redirect(to: "/")
  end

  def logout(conn, _params) do
    Plug.Conn.clear_session(conn)
    |> put_flash(:success, "You have been successfully logged out")
    |> redirect(to: "/")
  end


  def login_callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
  	|> put_flash(:error, "There was an error while authorizaiton. Plase try again")
  	|> redirect(to: "/")
  end

  def login_callback(%{assigns: %{ueberauth_auth: %{info: user}}} = conn, _params) do
    # case Accounts.get_user_by_email(user.email) do
    #  %Accounts.User{:user_id => id} -> redirect_existing_user(conn, id)   
    #  nil -> redirect_new_user(conn, user)
    # end
  end

  defp redirect_existing_user(conn, user_id) do
    conn
    |> put_session(:logged_user_id, user_id)
    |> put_flash(:success, "You have successfully signed in")
    |> redirect(to: "/")
  end

  def user_logged?(conn) do
    !!Plug.Conn.get_session(conn, :logged_user_id)
  end

  def get_current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :logged_user_id)

    Accounts.get_user!(user_id)
  end

  defp redirect_new_user(conn, user) do
    case Accounts.create_user(%{:name => user.name, :email => user.email}) do
      {:ok, %Accounts.User{:id => id}} -> 
        conn
        |> put_session(:logged_user_id, id)
        |> put_flash(:success, "You have successfully signed up")
        |> redirect(to: "/")
      {:error, _} -> 
        conn
        |> put_flash(:error, "There was an error during signing up")
        |> redirect(to: "/")
    end
  end
end
