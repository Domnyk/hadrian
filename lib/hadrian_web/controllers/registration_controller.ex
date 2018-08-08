defmodule HadrianWeb.RegistrationController do
  use HadrianWeb, :controller

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:success, "User registered.")
        |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    auth |> inspect |> IO.puts
  end

  # def edit(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # changeset = Accounts.change_user(user)
    # render(conn, "edit.html", user: user, changeset: changeset)
  # end
# 
  # def update(conn, %{"id" => id, "user" => user_params}) do
    # user = Accounts.get_user!(id)
# 
    # case Accounts.update_user(user, user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "User updated successfully.")
    #     |> redirect(to: user_path(conn, :show, user))
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "edit.html", user: user, changeset: changeset)
    # end
  # end
# 
  # def delete(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # {:ok, _user} = Accounts.delete_user(user)
# 
    # conn
    # |> put_flash(:info, "User deleted successfully.")
    # |> redirect(to: user_path(conn, :index))
  # end
end
