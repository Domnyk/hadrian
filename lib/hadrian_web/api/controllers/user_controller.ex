defmodule HadrianWeb.Api.UserController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner

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

  def update(conn, attrs) when is_map(attrs) do
    current_user_id =
      conn
      |> get_session(:current_user_id)

    current_user_type =
      conn
      |> get_session(:current_user_type)

    case current_user_type do
      :user -> update_user(conn, attrs, current_user_id)
      :complexes_owner -> update_complexes_owner(conn, attrs, current_user_id)
      _ ->
        Logger.error("Current_user_type is nil")
        halt(conn)
    end
  end

  defp update_user(conn, attrs, current_user_id) do
    user = Accounts.get_user!(current_user_id)

    case Accounts.update_user(user, attrs) do
      {:ok, %User{} = user} -> render(conn, "ok.create.json", user: user)
      {:error, changeset} -> render(conn, "error.create.json", changeset: changeset)
    end
  end

  defp update_complexes_owner(conn, attrs, current_user_id) do
    complexes_owner = Accounts.get_complexes_owner!(current_user_id)

    case Accounts.update_complexes_owner(complexes_owner, attrs) do
      {:ok, %ComplexesOwner{} = complexes_owner} -> render("ok.create.json", complexes_owner: complexes_owner)
      {:error, changeset} -> render(conn, "error.create.json", changeset: changeset)
    end
  end
end