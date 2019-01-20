defmodule HadrianWeb.Api.UserController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner
  alias HadrianWeb.Api.Helpers.Session

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create_client(conn, attrs) do
    with {:ok, %User{} = user} <- Accounts.create_user(attrs) do
      conn
      |> fetch_session()
      |> put_session(:current_user_id, user.id)
      |> put_session(:current_user_type, :client)
      |> redirect(external: Session.get_redirection_url(user))
    end
  end

  def create(conn, attrs) do
    with {:ok, %ComplexesOwner{} = complexes_owner} <- Accounts.create_complexes_owner(attrs) do
      conn
      |> fetch_session()
      |> put_session(:current_user_id, complexes_owner.id)
      |> render("show.json", complexes_owner: complexes_owner)
    end
  end

  def update(conn, attrs) when is_map(attrs) do
    current_user_id = Session.get_user_id(conn)

    case Session.get_user_type(conn) do
      :client -> update_client(conn, attrs, current_user_id)
      :owner -> update_complexes_owner(conn, attrs, current_user_id)
      _ ->
        Logger.error("Current_user_type is nil")
        halt(conn)
    end
  end

  defp update_client(conn, attrs, current_user_id) do
    user = Accounts.get_user!(current_user_id)

    case Accounts.update_user(user, attrs) do
      {:ok, %User{} = user} -> render(conn, "show.json", user: user)
      {:error, changeset} -> render(conn, "error.create.json", changeset: changeset)
    end
  end

  defp update_complexes_owner(conn, attrs, current_user_id) do
    complexes_owner = Accounts.get_complexes_owner!(current_user_id)

    case Accounts.update_complexes_owner(complexes_owner, attrs) do
      {:ok, %ComplexesOwner{} = complexes_owner} -> render(conn, "show.json", complexes_owner: complexes_owner)
    end
  end
end