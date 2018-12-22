defmodule HadrianWeb.Api.UserControllerTest do
  use HadrianWeb.ConnCase
  
  alias Hadrian.Accounts

  describe "create" do
    test "inserts user when data is valid", %{conn: conn} do
      attrs = string_params_for(:complexes_owner)
      complexes_owner_data = %{"complexes_owner" => attrs}
      conn = post conn, user_path(conn, :create), complexes_owner_data
      resp = json_response(conn, 200)
      user_from_db = Accounts.get_complexes_owner_by_email(resp["email"])

      assert user_from_db
    end

    test "returns json with user fields when data is valid", %{conn: conn} do
      attrs = string_params_for(:complexes_owner)
      complexes_owner_data = %{"complexes_owner" => attrs}
      conn = post conn, user_path(conn, :create), complexes_owner_data
      resp = json_response(conn, 200)

      assert resp["status"] == "ok"
      assert resp["email"] == attrs["email"]
    end

    test "returns status 'error' when data is invalid", %{conn: conn} do
      invalid_data = %{"complexes_owner" => %{}}

      conn = post conn, user_path(conn, :create), invalid_data
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
    end
  end
end