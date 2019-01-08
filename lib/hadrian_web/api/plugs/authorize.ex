defmodule HadrianWeb.Api.Plugs.Authorize do
  import Plug.Conn

  alias Hadrian.Repo
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner


  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    current_user_id =
      conn
      |> get_session(:current_user_id)

    case current_user_id do
      nil -> handle_unauthorized(conn)
      _ -> if user_exists?(current_user_id), do: conn, else: handle_unauthorized(conn)
    end
  end

  defp user_exists?(user_id) do
    case user_id do
      nil -> false
      _ -> Repo.get(User, user_id) || Repo.get(ComplexesOwner, user_id)
    end
  end

  defp handle_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(HadrianWeb.Api.ErrorView, :"401")
    |> halt()
  end
end
