defmodule HadrianWeb.Api.ParticipationControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Activities.Event
  alias Hadrian.Accounts.User

  setup %{conn: conn} do
    user = insert(:user)
    complexes_owner = insert(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: complexes_owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])
    event = insert(:event, sport_arena_id: sport_arena.id, participators: [user])

    {:ok, conn: put_req_header(conn, "accept", "application/json"), event: event, user: user}
  end

  describe "index" do
    setup [:sign_user_in]

    test "list participations in event", %{conn: conn, event: %Event{id: event_id}, user: %User{id: user_id}} do
      conn = get conn, event_participation_path(conn, :index, event_id)
      assert [%{"event_id" => ^event_id, "user_id" => ^user_id}] = json_response(conn, 200)["participations"]
    end
  end

  describe "create" do
    setup [:sign_user_in]

    test "creates new participation", %{conn: conn, event: %Event{id: event_id}} do
      current_user_id =
        conn
        |> fetch_session()
        |> get_session(:current_user_id)

      conn = post conn, event_participation_path(conn, :create, event_id)
      assert %{"event_id" => ^event_id, "user_id" => ^current_user_id} = json_response(conn, 201)
    end
  end

  describe "delete" do
    setup [:sign_user_in]

    test "deletes participation", %{conn: conn, event: %Event{id: event_id}} do
      current_user_id =
        conn
        |> fetch_session()
        |> get_session(:current_user_id)

      post conn, event_participation_path(conn, :create, event_id)
      conn = delete conn, event_participation_path(conn, :delete, event_id)
      assert %{"event_id" => ^event_id, "user_id" => ^current_user_id} = json_response(conn, 200)
    end
  end

  defp sign_user_in(%{conn: conn}) do
    user = insert(:user)
    conn_from_signed_in_user = Plug.Test.init_test_session(conn, %{current_user_id: user.id})

    {:ok, conn: conn_from_signed_in_user}
  end
end
