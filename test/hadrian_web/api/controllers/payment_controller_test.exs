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
    event = insert(:event, sport_arena_id: sport_arena.id, participators: [user])
    conn = Plug.Test.init_test_session(conn, %{current_user_id: user.id})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), event: event, user: user}
  end

  describe "verify payment plug" do
    test "returns 400 when attempt to approve in join phase", %{conn: conn, event: event} do
      joining_end = Date.add(Date.utc_today(), 2)
      paying_end = Date.add(joining_end, 4)
      event = insert(:event, end_of_joining_phase: joining_end, end_of_paying_phase: paying_end,
                     sport_arena_id: event.sport_arena_id)

      conn = get conn, event_payment_path(conn, :approve, event.id)
      assert json_response(conn, 400)
    end
  end
end
