defmodule HadrianWeb.Api.SessionController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Authentication
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner
  alias HadrianWeb.Api.Helpers.Session

  action_fallback HadrianWeb.Api.FallbackController

  # Only for dev env
  def new(conn, %{"id" => id, "redirect_url" => redirect_url}) do
    user = Accounts.get_user!(id)

    conn
    |> fetch_session()
    |> put_session(:current_user_id, id)
    |> put_session(:current_user_type, :client)
    |> redirect(external: redirect_url <> "#id=#{user.id}&paypal_email=#{user.paypal_email}&display_name=#{user.display_name}")
  end

  def new(conn, %{"redirect_url" => redirect_url}) do
    Session.user_signed_in?(conn)
    |> case do
         false ->
           Agent.start_link(fn -> redirect_url end, name: __MODULE__)
           redirect_to_fb(conn)
         true ->
           Logger.info("User already signed in")
           redirect(conn, external: redirect_url)
       end
  end

  def create(conn, params) do
    case params do
      %{"email" => email, "password" => password} -> handle_session_creation_with_password(conn, email, password)
      %{"code" => code} -> handle_fb_resp(conn, code)
      %{"error" => error, "error_reason" => error_reason} -> handle_error_from_fb(conn, error, error_reason)
      _ -> Logger.error("Params don't match any clause")
    end
  end

  def delete(conn, _params) do
    conn
    |> fetch_session()
    |> clear_session()
    |> render("ok.delete.json")
  end

  defp redirect_to_fb(conn) do
    redirect_uri = HadrianWeb.Endpoint.url <> "/api/session"
    fb_login_endpoint = Authentication.Facebook.get_sign_in_endpoint(System.get_env("FACEBOOK_APP_ID"), redirect_uri)

    Logger.debug("Sign in with FB. Redirecting to: #{fb_login_endpoint}")
    redirect conn, external: fb_login_endpoint
  end

  defp handle_session_creation_with_password(conn, email, password) do
    Session.user_signed_in?(conn)
    |> case do
         false -> handle_not_signed_in(conn, %{email: email, password: password})
         true -> render(conn, "warning.create.json", message: "Complexes owner has already signed in")
       end
  end

  defp handle_not_signed_in(conn_with_fetched_session, %{email: email, password: password}) do
    with {:ok, %ComplexesOwner{} = complexes_owner} <- Accounts.get_complexes_owner_by_email(email),
         :match <- Authentication.verify_password(password, complexes_owner.password_hash)
    do
      token = Plug.CSRFProtection.get_csrf_token()

       conn_with_fetched_session
       |> put_session(:current_user_id, complexes_owner.id)
       |> put_session(:current_user_type, :owner)
       |> put_session("_csrf_token", Process.get(:plug_unmasked_csrf_token))
       |> render("ok.create.json", complexes_owner: complexes_owner, csrf_token: token)
    else
      {:no_such_complexes_owner, _} -> render(conn_with_fetched_session, "invalid-credentials.json")
      :no_match -> render(conn_with_fetched_session, "invalid-credentials.json")
    end
  end

  defp handle_fb_resp(conn, code) do
    alias HadrianWeb.Api.UserController

    Logger.info("Successful FB login")
    fb = Application.get_env(:hadrian, :fb_access_token)

    with {:ok, access_token} <- fb.exchange_code_for_access_token(code),
         {:ok, user} <- fb.get_user(access_token),
         {:ok, %User{} = user} <- Accounts.get_user_by_fb(user) do
      Logger.info("User exists in DB. Creating session")
      conn
      |> fetch_session()
      |> put_session(:current_user_id, user.id)
      |> put_session(:current_user_type, :client)
      |> redirect(external: Session.get_redirection_url(user))
    else
      {:no_such_user, %{fb_id: id, name: name}} -> UserController.create_client(conn, %{fb_id: id, display_name: name, paypal_email: "test@test.com"})
    end
  end

  defp handle_error_from_fb(conn, error, error_reason) do
    redirect_url = Agent.get(__MODULE__, fn state -> state end)

    Logger.warn("Error during FB login. Error: #{error}, error reason: #{error_reason}")
    redirect conn, external: redirect_url
  end
end
