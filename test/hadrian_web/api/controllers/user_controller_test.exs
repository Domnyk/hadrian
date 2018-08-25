defmodule HadrianWeb.Api.UserControllerTest do
  use HadrianWeb.ConnCase
  
  describe "create" do
    test "hashes user's password", %{conn: conn} do
      conn = post conn, user_path(conn, :create), params: %{}
      conn
      |> inspect
      |> IO.puts

      assert false
    end
  end
end