defmodule HadrianWeb.EventControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Activities.Event

  @update_attrs %{}

  setup %{conn: conn} do
    complexes_owner = insert(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: complexes_owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])
    event = insert(:event, sport_arena_id: sport_arena.id)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), event: event}
  end

  describe "index" do
    test "lists all events", %{conn: conn, event: event} do
      conn = get conn, event_path(conn, :index)
      assert json_response(conn, 200)["data"] == [%{"id" => event.id}]
    end
  end

  describe "create event" do
    setup [:sign_user_in]

    test "renders event when data is valid", %{conn: conn, event: %Event{sport_arena_id: sport_arena_id}} do
      create_attrs =
        string_params_for(:event, sport_arena_id: sport_arena_id)
        |> prepare_time_attrs()

      conn = post conn, event_path(conn, :create), event: create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{"id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: get_invalid_attrs()
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

  describe "update event" do
    setup [:sign_user_in]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, event_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: get_invalid_attrs()
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:sign_user_in]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp sign_user_in(%{conn: conn}) do
    conn_from_signed_in_user = Plug.Test.init_test_session(conn, %{current_user_id: Enum.random(0..1000)})

    {:ok, conn: conn_from_signed_in_user}
  end

  defp get_invalid_attrs() do
    string_params_for(:event)
    |> Enum.map(fn {k, _} -> {k, nil} end)
    |> Map.new()
  end
end
