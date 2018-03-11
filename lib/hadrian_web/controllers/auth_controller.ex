defmodule HadrianWeb.AuthController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts

  plug Ueberauth

  def request(conn, _params) do
    render conn, "index.html"
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
  	|> put_flash(:error, "There was an error while authorizaiton. Plase try again")
  	|> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: %{info: user}}} = conn, _params) do
    case Accounts.get_user_by_email(user.email) do
      %Accounts.User{:id => id} -> redirect_existing_user(conn, id)   
      nil -> redirect_new_user(conn, user)
    end
  end

  defp redirect_existing_user(conn, user_id) do
    conn
    |> put_session(:logged_user_id, user_id)
    |> put_flash(:success, "You have successfully signed in")
    |> redirect(to: "/")
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
