defmodule HadrianWeb.Api.UserController do
  use HadrianWeb, :controller

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end
end