defmodule HadrianWeb.Api.TokenController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Guardian
  alias Hadrian.Facebook
  alias Hadrian.Security

  @endpoint_failure "https://localhost:8080/sign_in?sign_in_status=error"
  @endpoint_success "https://localhost:8080/map?sign_in_status=success"

  def redirect_to_fb(conn, _params) do
    fb_login_endpoint = Facebook.get_login_endpoint(System.get_env("FACEBOOK_APP_ID"), 
                                                    Application.get_env(:hadrian, :fb_redirect_uri))

    Logger.debug("Redirecting to: #{fb_login_endpoint}")
    redirect conn, external: fb_login_endpoint
  end

  def handle_fb_login_resp(conn, %{"error" => error, "error_reason" => error_reason}) do
    Logger.warn("Error during FB login. Error: #{error}, error reason: #{error_reason}")
    redirect conn, external: @endpoint_failure
  end

  def handle_fb_login_resp(conn, %{"code" => code}) do
    Logger.info("Succesful FB login")

    with {:ok, access_token} <- Facebook.exchange_code_for_access_token(code),
         {:ok, user_email} <- Facebook.get_user_email(access_token),
         %User{} = user <- Accounts.get_user_by_email(user_email),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user)
    do
      Logger.info("User exists in DB. Token has been generated")
      redirect conn, external: (@endpoint_success <> "#token=#{token}")
    else
      {:error, error_data} ->
        Logger.warn("Error during user token generation: #{inspect(error_data)}")
        redirect conn, external: @endpoint_failure    
    end
  end

  def create(conn, %{"auth_method" => "in_app", "user" => user_params} = params) do
    with %User{} = user <- Accounts.get_user_by_email(user_params["email"]),
         {:ok, %User{}} <- Security.authenticate(user, user_params["password"]),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user)
    do
      Logger.info("User exists in DB. Token has been generated")
      render(conn, "ok.create.json", token: token, current_user: user)
    else
      {:error, "Password missmatch"} -> render(conn, "error.create.json", reason: "Password missmatch")
    end
  end

  def create(conn, _params) do
    render(conn, "error.create.json", reason: "Not enough data")
  end
end