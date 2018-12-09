defmodule HadrianWeb.EventControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Activities.Event

  @update_attrs %{ users: [] }

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

  # TODO: Compare all fields
  describe "index" do
    test "lists all events in sport arena", %{conn: conn, event: %Event{id: id} = event} do
      conn = get conn, sport_arena_event_path(conn, :index, event.sport_arena_id)
      assert [%{"id" => ^id}] = json_response(conn, 200)["data"]
    end
  end

  describe "create event" do
    setup [:sign_user_in]

    test "renders event when data is valid", %{conn: conn, event: %Event{sport_arena_id: sport_arena_id}} do
      create_attrs =
        string_params_for(:event, sport_arena_id: sport_arena_id)
        |> prepare_time_attrs()

      conn = post conn, sport_arena_event_path(conn, :create, sport_arena_id), event: create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, sport_arena_event_path(conn, :show, sport_arena_id ,id)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = get_invalid_attrs()
      |> Map.put("users", [])

      conn = post conn, sport_arena_event_path(conn, :create, "-1"), event: invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    defp prepare_time_attrs(event_attrs) do
      event_attrs
      |> Enum.map(fn {k, v} ->
        case k do
          "start_time" -> {"start_time", %{"hour" => Map.get(v, "hour"), "minute" => Map.get(v, "minute")}}
          "end_time" -> {"end_time", %{"hour" => Map.get(v, "hour"), "minute" => Map.get(v, "minute")}}
          _ -> {k, v}
        end
      end)
      |> Map.new()
    end
  end

  # TODO: Compare all fields
  describe "update event" do
    setup [:sign_user_in]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, sport_arena_event_path(conn, :update, event.sport_arena_id, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, sport_arena_event_path(conn, :show, event.sport_arena_id, id)
      resp = json_response(conn, 200)

      assert event.id == resp["data"]["id"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      invalid_attrs = get_invalid_attrs()
      |> Map.put("users", [])

      conn = put conn, sport_arena_event_path(conn, :update, event.sport_arena_id, event), event: invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:sign_user_in]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, sport_arena_event_path(conn, :delete, event.sport_arena_id, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, sport_arena_event_path(conn, :show, event.sport_arena_id, event)
      end
    end
  end

  defp sign_user_in(%{conn: conn}) do
    user = insert(:user)
    conn_from_signed_in_user = Plug.Test.init_test_session(conn, %{current_user_id: user.id})

    {:ok, conn: conn_from_signed_in_user}
  end

  defp get_invalid_attrs() do
    string_params_for(:event)
    |> Enum.map(fn {k, _} -> {k, nil} end)
    |> Map.new()
  end
end
