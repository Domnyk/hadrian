defmodule HadrianWeb.Api.TokenController do
  use HadrianWeb, :controller

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Guardian
  alias Hadrian.Session

  def create(conn, %{"auth_method" => "facebook", "user" => %{"email" => _, "access_token" => _}} = params) do
    maybe_generate_token(conn, params)
  end

  def create(conn, %{"auth_method" => "in_app", "user" => %{"email" => _, "password" => _}} = params) do
    maybe_generate_token(conn, params)
  end

  def create(conn, _params) do
    render(conn, "error.create.json", reason: "Not enough data")
  end

  defp maybe_generate_token(conn, user_params) do
    case Session.login(user_params) do
      {:ok, %User{} = user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        render(conn, "ok.create.json", jwt: token)
      {:error, _} ->
        render(conn, "error.create.json", reason: "Error during sign in")
    end
  end
end