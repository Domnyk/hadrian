defmodule HadrianWeb.Api.UserControllerTest do
  use HadrianWeb.ConnCase
  
  alias Hadrian.Accounts

  describe "create" do
    test "inserts owner when data is valid", %{conn: conn} do
      attrs = string_params_for(:complexes_owner)
      conn = post conn, user_path(conn, :create), attrs
      resp = json_response(conn, 200)

      assert Accounts.get_complexes_owner!(resp["id"])
    end

    test "returns json with user fields when data is valid", %{conn: conn} do
      attrs = string_params_for(:complexes_owner)
      conn = post conn, user_path(conn, :create), attrs
      resp = json_response(conn, 200)

      assert resp["id"]
      assert resp["email"] == attrs["email"]
      assert resp["paypal_email"] == attrs["paypal_email"]
    end

    test "returns errors when data is invalid", %{conn: conn} do
      invalid_data = %{}

      conn = post conn, user_path(conn, :create), invalid_data
      resp = json_response(conn, 422)

      assert resp["email"]
      assert resp["password"]
      assert resp["paypal_email"]
    end
  end
end