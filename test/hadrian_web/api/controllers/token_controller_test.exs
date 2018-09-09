defmodule HadrianWeb.Api.TokenControllerTest do
  use HadrianWeb.ConnCase

  describe "create when body is empty" do
    test "returns response with status equal to :error", %{conn: conn} do
      conn = post conn, token_path(conn, :create)
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
      assert resp["reason"] == "Not enough data"
    end
  end

  describe "create when 'auth_method' key is not present in body" do
    test "returns response with status equal to :error", %{conn: conn} do
      conn = post conn, token_path(conn, :create)
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
      assert resp["reason"] == "Not enough data"
    end
  end

  describe "create when 'auth_method key is present in body and equals to 'in_app'" do
  end

  describe "create when 'auth_method' key is present in body and equals to 'facebook'" do
    test ~s(when body has not user.email field returns response with status "error"), %{conn: conn} do      
      body = %{"auth_method" => "facebook", "user" => %{"access_token" => "12345"}}
      conn = post conn, token_path(conn, :create), body
      resp = json_response(conn, 200)
      
      assert resp["status"] == "error"
      assert resp["reason"] == "Not enough data" 
    end

    test ~s(when body has not user.access_token field returns response with status "error"), %{conn: conn} do      
      body = %{"auth_method" => "facebook", "user" => %{"email" => "test@domain.com"}}
      conn = post conn, token_path(conn, :create), body
      resp = json_response(conn, 200)
      
      assert resp["status"] == "error"
      assert resp["reason"] == "Not enough data" 
    end

    test ~s(when access token is empty returns response with status "error"), %{conn: conn} do      
      body = %{"auth_method" => "facebook", "user" => %{"email" => "test@domain.com", "access_token" => ""}}
      conn = post conn, token_path(conn, :create), body
      resp = json_response(conn, 200)
      
      assert resp["status"] == "error"
      assert resp["reason"] == "Error during sign in" 
    end

    test ~s(when access token is valid and user isn't in DB returns response with status "error"), %{conn: conn} do
      access_token = "CAAEe4ALTtoMBAPfhNONNBJcfFsT3C9C1ky3tZAXxF9k4HBybM7o3V8bGofuXOtz6TgIEGObmDSKwUGr0LYZChBTMU2QtP" <>
        "5995mkteEMsqyKHuVr9rUbEFvHT7kz7Rjkw3rxeUfxNKRdZBQ3ym4YZB4FFKuAbhzrxe2ltYhxEQKEXepJ2q7oITJ2w2j7A7vBiZB9JNC4k" <>
        "fRwZDZD"
      body = %{"auth_method" => "facebook", "user" => %{"email" => "test@domain.com", "access_token" => access_token}}
      conn = post conn, token_path(conn, :create), body
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
      assert resp["reason"] == "Error during sign in"
    end

    test ~s(when access token is valid and user is in DB returns response with jwt), %{conn: conn} do
      access_token = "CAAEe4ALTtoMBAPfhNONNBJcfFsT3C9C1ky3tZAXxF9k4HBybM7o3V8bGofuXOtz6TgIEGObmDSKwUGr0LYZChBTMU2QtP" <>
        "5995mkteEMsqyKHuVr9rUbEFvHT7kz7Rjkw3rxeUfxNKRdZBQ3ym4YZB4FFKuAbhzrxe2ltYhxEQKEXepJ2q7oITJ2w2j7A7vBiZB9JNC4k" <>
        "fRwZDZD"
      user = insert(:user)
      body = %{"auth_method" => "facebook", "user" => %{"email" => user.email, "access_token" => access_token}}
      conn = post conn, token_path(conn, :create), body
      resp = json_response(conn, 200)

      assert resp["status"] == "ok"
      assert resp["jwt"]
    end
  end

  describe "create when 'auth_method' key is present in body and equals to non existing authentication method" do
    test ~s(returns response with error status), %{conn: conn} do      
      body = %{"auth_method" => "non_existing_auth_method"}
      conn = post conn, token_path(conn, :create), body
      resp = json_response(conn, 200)
      
      assert resp["status"] == "error"
      assert resp["reason"] == "Not enough data" 
    end  
  end
end