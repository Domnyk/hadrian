defmodule HadrianWeb.SessionController do
  use HadrianWeb, :controller

  alias Hadrian.Session

  plug Ueberauth

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, :in_app) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:success, "Signed in")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:error, "Wrong email or password")
        |> render("new.html")
    end
  end

  def create(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do    
    case Session.login(auth.extra.raw_info.user, :facebook) do
      {:ok, user} -> 
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:success, "Signed in")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:error, "Wrong email or password")
        |> render("new.html")
      end
  end

  def create(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to sign in")
    |> redirect(to: "/")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:success, "Signed out")
    |> redirect(to: "/")
  end
end