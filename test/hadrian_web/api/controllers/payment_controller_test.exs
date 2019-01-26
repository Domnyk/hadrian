defmodule HadrianWeb.Api.PaymentControllerTest do
  use HadrianWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user)
    complexes_owner = insert(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: complexes_owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])
    conn = Plug.Test.init_test_session(conn, %{current_user_id: user.id, current_user_type: :client})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), sport_arena: sport_arena, user: user}
  end

  describe "verify payment plug" do
    test "returns 400 when attempt to approve in join phase", %{conn: conn, sport_arena: sport_arena} do
      joining_end = Date.add(Date.utc_today(), 2)
      paying_end = Date.add(joining_end, 4)
      event = insert(:event, end_of_joining_phase: joining_end, end_of_paying_phase: paying_end,
                     sport_arena_id: sport_arena.id)

      conn = get conn, event_payment_path(conn, :approve, event.id)
      assert json_response(conn, 400)
    end
  end

  describe "verify client authorization plug" do
    test "returns 401 when owner attempts to approve transaction", %{conn: conn, sport_arena: sport_arena, user: user} do
      conn = sign_in_as_owner(conn, user.id)
      joining_end = Date.add(Date.utc_today(), -2)
      paying_end = Date.add(joining_end, 4)
      event = insert(:event, end_of_joining_phase: joining_end, end_of_paying_phase: paying_end,
        sport_arena_id: sport_arena.id)

      conn = get conn, event_payment_path(conn, :approve, event.id)
      assert json_response(conn, 401)
    end

    test "returns 401 when owner attempts to execute transaction", %{conn: conn, sport_arena: sport_arena, user: user} do
      conn = sign_in_as_owner(conn, user.id)
      joining_end = Date.add(Date.utc_today(), -2)
      paying_end = Date.add(joining_end, 4)
      event = insert(:event, end_of_joining_phase: joining_end, end_of_paying_phase: paying_end,
        sport_arena_id: sport_arena.id)

      conn = get conn, event_payment_path(conn, :approve, event.id)
      assert json_response(conn, 401)
    end

    defp sign_in_as_owner(conn, user_id) do
      Plug.Test.init_test_session(conn, %{current_user_id: user_id, current_user_type: :owner})
    end
  end
end
