defmodule HadrianWeb.Api.SessionController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Authentication
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User

  # Only for FB call
  def new(conn, _params) do

  end

  defp redirect_to_fb(conn) do
    fb_login_endpoint = Authentication.Facebook.get_sign_in_endpoint(System.get_env("FACEBOOK_APP_ID"),
                                                                   get_redirect_endpoint())

    Logger.debug("Sign in with FB. Redirecting to: #{fb_login_endpoint}")
    redirect conn, external: fb_login_endpoint
  end

  def create(conn, %{"email" => email, "password" => password}) do
    conn
    |> fetch_session()
    |> get_session(:current_user_id)
    |> case do
         nil -> handle_unsigned_user(conn, %{email: email, password: password})
         _ -> handle_signed_in_user(conn)
       end
    end

  defp handle_unsigned_user(conn_with_fetched_session, %{email: email, password: password}) do
    with {:ok, %User{} = user} = Accounts.get_user_by_email(email),
         :match = Authentication.verify_password(password, user.password_hash)
    do
       conn_with_fetched_session
       |> put_session(:current_user_id, user.id)
       |> render("ok.create.json")
    end
  end

  defp handle_signed_in_user(conn_with_fetched_session) do
    render(conn_with_fetched_session, "warning.create.json", message: "User has already signed in")
  end

  def delete(conn, _params) do
    conn
    |> fetch_session()
    |> clear_session()
    |> render("ok.delete.json")
  end
end
