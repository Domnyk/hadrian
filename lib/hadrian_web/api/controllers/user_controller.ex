defmodule HadrianWeb.Api.UserController do
  use HadrianWeb, :controller

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias HadrianWeb.Api.PasswordHelper
  
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"password" => password} = params) do
    params = params
    |> Map.put("password_hash", PasswordHelper.create_hash(password))

    case Accounts.create_user(params) do
      {:ok, user} ->
        render(conn, "ok.create.json", user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.create.json", errors: changeset.errors)
    end
  end
end