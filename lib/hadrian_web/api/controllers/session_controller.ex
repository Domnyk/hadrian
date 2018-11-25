defmodule HadrianWeb.Api.SessionController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Authentication
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner

  def new(conn, %{"redirect_url" => redirect_url}) do
    check_sign_in_status(conn)
    |> case do
         :not_signed_in ->
           Agent.start_link(fn -> redirect_url end, name: __MODULE__)
           redirect_to_fb(conn)
         :signed_in -> redirect(conn, external: redirect_url)
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
    check_sign_in_status(conn)
    |> case do
         :not_signed_in -> handle_not_signed_in(conn, %{email: email, password: password})
         :signed_in -> render(conn, "warning.create.json", message: "Complexes owner has already signed in")
       end
  end

  defp check_sign_in_status(conn) do
    conn
    |> fetch_session()
    |> get_session(:current_user_id)
    |> case do
         nil -> :not_signed_in
         _ -> :signed_in
       end
  end

  defp handle_not_signed_in(conn_with_fetched_session, %{email: email, password: password}) do
    with {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.get_complexes_owner_by_email(email),
         :match = Authentication.verify_password(password, complexes_owner.password_hash)
    do
       conn_with_fetched_session
       |> put_session(:current_user_id, complexes_owner.id)
       |> render("ok.create.json")
    end
  end

  defp handle_fb_resp(conn, code) do
    Logger.info("Successful FB login")
    redirect_url = Agent.get(__MODULE__, fn state -> state end)

    with {:ok, access_token} <- Authentication.Facebook.exchange_code_for_access_token(code),
         {:ok, user_email} <- Authentication.Facebook.get_user_email(access_token),
         {:ok, %User{} = user} <- Accounts.get_user_by_email(user_email)
    do
      Logger.info("User exists in DB. Creating session")
      conn
      |> fetch_session()
      |> put_session(:current_user_id, user.id)
      |> redirect(external: redirect_url)
  else
    {:no_such_user, email: email} ->
      Logger.info("No user in database with such email: #{inspect(email)}. Creating user")
      Logger.info("Email: " <> email)
      {:ok, %User{} = user} = Accounts.create_user(%{email: email})
      conn
      |> fetch_session()
      |> put_session(:current_user_id, user.id)
      |> redirect(external: redirect_url)
  end

end

  defp handle_error_from_fb(conn, error, error_reason) do
    redirect_url = Agent.get(__MODULE__, fn state -> state end)

    Logger.warn("Error during FB login. Error: #{error}, error reason: #{error_reason}")
    redirect conn, external: redirect_url
  end
end
