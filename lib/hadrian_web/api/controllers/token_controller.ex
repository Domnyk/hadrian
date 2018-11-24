defmodule HadrianWeb.Api.TokenController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Guardian
  alias Hadrian.Facebook
  alias Hadrian.Security


  @failure_endpoint "#{Application.get_env(:hadrian, :client_url)}/sign_in?sign_in_status=error"

  def redirect_to_fb(conn, _params) do
    fb_login_endpoint = Facebook.get_login_endpoint(System.get_env("FACEBOOK_APP_ID"), 
                                                    get_redirect_endpoint())

    Logger.debug("Redirecting to: #{fb_login_endpoint}")
    redirect conn, external: fb_login_endpoint
  end

  def handle_fb_sign_in_resp(conn, %{"error" => error, "error_reason" => error_reason}) do
    Logger.warn("Error during FB login. Error: #{error}, error reason: #{error_reason}")
    redirect conn, external: @failure_endpoint
  end

  def handle_fb_sign_in_resp(conn, %{"code" => code}) do
    Logger.info("Succesful FB login")

    with {:ok, access_token} <- Facebook.exchange_code_for_access_token(code, get_redirect_endpoint()),
         {:ok, user_email} <- Facebook.get_user_email(access_token),
         {:ok, %User{} = user} <- Accounts.get_user_by_email(user_email),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user)
    do
      Logger.info("User exists in DB. Token has been generated")
      success_endpoint = "#{Application.get_env(:hadrian, :client_url)}/map?sign_in_status=success"
      redirect conn, external: (success_endpoint <> "#token=#{token}")
    else
      {:error, error_data} ->
        Logger.warn("Error during user token generation: #{inspect(error_data)}")
        redirect conn, external: @failure_endpoint    
    end
  end

  def create(conn, %{"auth_method" => "in_app", "user" => user_params}) do
    with {:ok, %User{} = user}  <- Accounts.get_user_by_email(user_params["email"]),
         :match <- Security.authenticate(user.password_hash, user_params["password"]),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user)
    do
      Logger.info("User exists in DB. Token has been generated")
      render(conn, "ok.create.json", token: token, current_user: user)
    else
      {:error, _} -> render(conn, "error.create.json", reason: "Wrong email or password")
    end
  end

  def create(conn, _params) do
    render(conn, "error.create.json", reason: "Wrong data for sign in")
  end

  defp get_redirect_endpoint do
    HadrianWeb.Endpoint.url <> "/api/token/new_callback"
  end
end