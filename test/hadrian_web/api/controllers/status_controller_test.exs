defmodule HadrianWeb.StatusControllerTest do
  use HadrianWeb.ConnCase

  describe "index" do
    test "returns 'online'", %{conn: conn} do
      conn = get conn, status_path(conn, :index)

      resp = json_response(conn, 200)
      assert resp == "online"
    end
  end

end
