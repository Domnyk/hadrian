defmodule HadrianWeb.Api.UserController do
  use HadrianWeb, :controller

  alias Hadrian.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"complexes_owner" => complexes_owner_params}) do
    case Accounts.create_complexes_owner(complexes_owner_params) do
      {:ok, complexes_owner} ->
        conn
        |> fetch_session()
        |> put_session(:current_user_id, complexes_owner.id)
        |> render("ok.create.json", complexes_owner: complexes_owner)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.create.json", changeset: changeset)
    end
  end
end