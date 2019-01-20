defmodule HadrianWeb.Api.Helpers.Session do
  import Plug.Conn

  alias Hadrian.Accounts.User

  def get_user_id(%Plug.Conn{} = conn) do
    conn
    |> fetch_session()
    |> get_session(:current_user_id)
  end

  def get_user_type(%Plug.Conn{} = conn) do
    conn
    |> fetch_session()
    |> get_session(:current_user_type)
  end

  def user_signed_in?(%Plug.Conn{} = conn) do
    case get_user_id(conn) do
      id when is_number(id) -> true
      _ -> false
    end
  end

  def get_redirection_url(%User{} = user) do
    redirect_url = Application.get_env(:hadrian, :client_url)
    params = "/#paypal_email=#{user.paypal_email}&display_name=#{user.display_name}&id=#{user.id}"

    redirect_url <> params
  end
end
