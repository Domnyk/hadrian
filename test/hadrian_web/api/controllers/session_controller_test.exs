defmodule HadrianWeb.Api.SessionControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Accounts
  alias Hadrian.Accounts.User
  alias Hadrian.Accounts.ComplexesOwner

  setup %{conn: conn} do
    conn_with_session = Plug.Test.init_test_session(conn, %{})

    {:ok, conn: conn_with_session}
  end

  describe "create/2 when passwords match" do
    test "creates session with current user field", %{conn: conn} do
      complexes_owner_attrs = build(:complexes_owner_attrs)
      {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(complexes_owner_attrs)

      conn = post conn, session_path(conn, :create, complexes_owner_attrs)

      assert json_response(conn, 200) == %{"status" => "ok", "email" => complexes_owner_attrs["email"]}
      assert Plug.Conn.get_session(conn, :current_user_id) == complexes_owner.id
    end

    test "sends warning when user tries to sign in when already signed", %{conn: conn} do
      complexes_owner_attrs = build(:complexes_owner_attrs)
      {:ok, %ComplexesOwner{} = complexes_owner} = Accounts.create_complexes_owner(complexes_owner_attrs)

      # Initializing session this way depends makes it dependent on how current user is stored.
      # Ideally: request is made, then second request with session set to first request's session value is made
      # TODO: Refactor session initialization
      response =
        conn
        |> Plug.Test.init_test_session(current_user_id: complexes_owner.id)
        |> post(session_path(conn, :create, complexes_owner_attrs))
        |> json_response(200)

      assert Map.get(response, "status") == "warning"
      assert Map.get(response, "message") == "Complexes owner has already signed in"
    end

    test "sends response with user data", %{conn: conn} do
      complexes_owner_attrs = build(:complexes_owner_attrs)
      {:ok, %ComplexesOwner{}} = Accounts.create_complexes_owner(complexes_owner_attrs)

      response =
        conn
        |> post(session_path(conn, :create, complexes_owner_attrs))
        |> json_response(200)

      assert response == %{"status" => "ok", "email" => complexes_owner_attrs["email"]}
    end
  end

  describe "delete/1" do
    test "clears session", %{conn: conn} do
      user_attrs = build(:user_attrs)
      {:ok, %User{} = user} = Accounts.create_user(user_attrs)

      conn_with_session = Plug.Test.init_test_session(conn, current_user_id: user.id)
      assert Plug.Conn.get_session(conn_with_session, :current_user_id) == user.id

      conn_without_session = delete(conn_with_session, session_path(conn, :delete))
      assert json_response(conn_without_session, 200) == %{"status" => "ok"}
      assert Plug.Conn.get_session(conn_without_session, :current_user_id) == nil
    end
  end

end
