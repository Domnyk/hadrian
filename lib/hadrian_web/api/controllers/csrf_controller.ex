defmodule HadrianWeb.Api.CsrfController do
  use HadrianWeb, :controller

  def index(conn, _opts) do
    token = Plug.CSRFProtection.get_csrf_token()

    conn
    |> put_resp_cookie("XSRF-TOKEN", token, http_only: :false, domain: Application.get_env(:hadrian, :domain))
    |> send_resp(:ok, "")
  end

end
