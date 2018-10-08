defmodule HadrianWeb.Api.TokenControllerTest do
  use HadrianWeb.ConnCase


  describe "redirect_to_fb" do
    test "redirects to facebook sign in endpoint", %{conn: conn} do
      conn = get conn, token_path(conn, :redirect_to_fb)

      redirected_conn = redirected_to(conn)
      assert redirected_conn =~ "https://www.facebook.com/v3.1/dialog/oauth"
    end

    test "sets proper url parameters", %{conn: conn} do
      conn = get conn, token_path(conn, :redirect_to_fb)

      redirected_conn = redirected_to(conn)
      assert redirected_conn =~ "client_id=#{System.get_env("FACEBOOK_APP_ID")}"
      assert redirected_conn =~ "&redirect_uri=#{HadrianWeb.Endpoint.url}/api/token/new_callback"
      assert redirected_conn =~ "&scope=email"
    end
  end

  describe "handle_fb_sign_in_resp when sign in failed" do
    test "redirects to client application with url parameter 'sign_in_status' equal to 'error'", %{conn: conn} do
      connection_params = %{"error" => "access_denied", "error_reason" => "user_denied"}
      conn = get conn, token_path(conn, :handle_fb_sign_in_resp), connection_params

      redirected_conn = redirected_to(conn)
      assert redirected_conn =~ Application.get_env(:hadrian, :client_url)
      assert redirected_conn =~ "?sign_in_status=error"
    end
  end

  describe "handle_fb_sign_in_resp when sign in succeded" do
    # TODO: Implement this test suite
  end

  describe "create with login and password" do
    test "when user exists in DB returns JWT token", %{conn: conn} do
      {:ok, email, password} = create_user("bob@test.com", "Good password")

      post_params = %{"auth_method" => "in_app", "user" => %{"email" => email , "password" => password}}
      conn = post conn, token_path(conn, :create), post_params
      resp = json_response(conn, 200)

      assert resp["token"]
      assert resp["status"] == "ok"
      assert resp["email"] == email 
      assert resp["access_type"] == "admin" # This value is hardcoced in controller for now
    end

    test "when user does not exist returns 'Wrong user or password'", %{conn: conn} do
      post_params = %{"auth_method" => "in_app", "user" => %{"email" => "non@existing.com"}}
      conn = post conn, token_path(conn, :create), post_params
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
      assert resp["reason"] == "Wrong email or password"
    end

    test "when password is wrong returns 'Wrong user or password'", %{conn: conn} do
      {:ok, email, _password} = create_user("bob@test.com", "Good password")

      post_params = %{"auth_method" => "in_app", "user" => %{"email" => email , "password" => "Bad password"}}
      conn = post conn, token_path(conn, :create), post_params
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
      assert resp["reason"] == "Wrong email or password"
    end
  end

  describe "create/2 when params don't match other create/2 definitions" do
    test "returns response with status equal to :error", %{conn: conn} do
      conn = post conn, token_path(conn, :create)
      resp = json_response(conn, 200)

      assert resp["status"] == "error"
      assert resp["reason"] == "Wrong data for sign in"
    end
  end

  defp create_user(email, password) do
    alias Hadrian.Accounts

    user_params = %{"email" => email, "password" => password}
    Accounts.create_user(user_params)
    {:ok, email, password}
  end
end