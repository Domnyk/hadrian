defmodule HadrianWeb.RegistrationController do
  use HadrianWeb, :controller

  alias Hadrian.Registration
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias HadrianWeb.RolesListHelper

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset, roles: get_adjusted_roles())
  end

  def create(conn, %{"user" => user_params}) do
    case Registration.register_user(user_params, :in_app) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:success, "Signed up")
        |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, roles: get_adjusted_roles())
    end
  end

  defp get_adjusted_roles() do
    Accounts.list_roles()
    |> RolesListHelper.adjust_for_view()
  end
end
