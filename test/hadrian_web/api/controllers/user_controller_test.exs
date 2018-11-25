defmodule HadrianWeb.Api.UserControllerTest do
  use HadrianWeb.ConnCase
  
  alias Hadrian.Accounts

  describe "create" do
    test "inserts user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), Map.from_struct(build(:user))
      resp = json_response(conn, 200)
      user_from_db = Accounts.get_user!(resp["id"])

      assert user_from_db
    end

    test "returns json with user fields when data is valid", %{conn: conn} do
      user_data = Map.from_struct(build(:user))
      conn = post conn, user_path(conn, :create), user_data
      resp = json_response(conn, 200)

      assert resp["id"]
      assert resp["email"] == user_data.email
    end

    test "returns json with display name when this field was set", %{conn: conn} do
      user_data = Map.from_struct(build(:user, display_name: "Steve Short"))
      conn = post conn, user_path(conn, :create), user_data
      resp = json_response(conn, 200)

      assert resp["id"]
      assert resp["email"] == user_data.email
      assert resp["display_name"] == user_data.display_name
    end

    test "returns json with field 'status' set to 'ok' when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), Map.from_struct(build(:user))
      resp = json_response(conn, 200)

      assert resp["status"] == "ok"
    end

    test "return json with information which field did not validate when data is invalid", %{conn: conn} do
      email = "test@domain.com"
      insert(:user, email: email)

      conn = post conn, user_path(conn, :create), Map.from_struct(build(:user, email: email))
      resp = json_response(conn, 200)

      assert Kernel.get_in(resp, ["errors", "email"]) == ["has already been taken"]
    end

    test "return json with field 'status' set to 'error' when email is not unique", %{conn: conn} do
      email = "test@domain.com"
      insert(:user, email: email)

      conn = post conn, user_path(conn, :create), Map.from_struct(build(:user, email: email))
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
    end

    test "return json with field 'status' set to 'error' when password is nil", %{conn: conn} do
      conn = post conn, user_path(conn, :create), %{"email" => "test@domain.com"}
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
    end
  end
end