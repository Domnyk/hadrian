defmodule ExternalEventControllerTest do
  @moduledoc false

  use HadrianWeb.ConnCase

  alias Hadrian.Activities.ExternalEvent

  setup %{conn: conn} do
    [owner, owner_2] = insert_pair(:complexes_owner)
    user = insert(:user)
    sport_complex = insert(:sport_complex, complexes_owner_id: owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    football = insert(:sport_discipline, name: "Football")
    basketball = insert(:sport_discipline, name: "Basketball")
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id, sport_disciplines: [football, basketball])
    external_event = insert(:external_event, sport_arena_id: sport_arena.id)
    conn = Plug.Test.init_test_session(conn, %{current_user_id: owner.id, current_user_type: :owner})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), external_event: external_event, user: user, owner_2: owner_2}
  end

  describe "index" do
    test "lists all external events in sport arena", %{conn: conn, external_event: %ExternalEvent{id: id} = external_event} do
      conn = get conn, sport_arena_external_event_path(conn, :index, external_event.sport_arena_id)
      assert [%{"id" => ^id}] = json_response(conn, 200)
    end
  end

  describe "create event" do
    setup [:sign_owner_in]

    test "renders external event when data is valid", %{conn: conn, external_event: %ExternalEvent{sport_arena_id: sport_arena_id}} do
      create_attrs =
        string_params_for(:external_event, sport_arena_id: sport_arena_id)
        |> prepare_time_attrs()

      conn = post conn, sport_arena_external_event_path(conn, :create, sport_arena_id), create_attrs
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, external_event_path(conn, :show, id)
      assert %{"id" => ^id} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = get_invalid_attrs()

      conn = post conn, sport_arena_external_event_path(conn, :create, "-1"), invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "does not allow client to create external_event", %{conn: conn, user: user} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: user.id, current_user_type: :client})
      attrs = get_invalid_attrs()

      conn = post conn, sport_arena_external_event_path(conn, :create, "-1"), attrs
      assert json_response(conn, 401)
    end

    defp prepare_time_attrs(external_event_attrs) do
      external_event_attrs
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

  describe "update external_event" do
    test "renders external_event when data is valid", %{conn: conn, external_event: %ExternalEvent{id: id} = external_event} do
      update_attrs = %{"start_time" => "13:00", "end_time" => "14:00"}
      conn = put conn, external_event_path(conn, :update, id), update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, external_event_path(conn, :show, id)
      resp = json_response(conn, 200)

      assert external_event.id == resp["id"]
    end

    test "renders errors when data is invalid", %{conn: conn, external_event: external_event} do
      invalid_attrs = get_invalid_attrs()

      conn = put conn, external_event_path(conn, :update, external_event.id), invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "does not allow client to edit external_event", %{conn: conn, external_event: external_event, user: user} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: user.id, current_user_type: :client})
      attrs = get_invalid_attrs()

      conn = put conn, external_event_path(conn, :update, external_event.id), external_event: attrs
      assert json_response(conn, 401)
    end

    test "does not allow owner to edit external_event that's not his", %{conn: conn, external_event: external_event, owner_2: owner_2} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: owner_2.id, current_user_type: :owner})
      attrs = get_invalid_attrs()

      conn = put conn, external_event_path(conn, :update, external_event.id), external_event: attrs
      assert json_response(conn, 401)
    end
  end

  describe "delete external_event" do
    test "deletes chosen external_event", %{conn: conn, external_event: external_event} do
      conn = delete conn, external_event_path(conn, :delete, external_event.id)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, external_event_path(conn, :show, external_event.id)
      end
    end

    test "does not allow client to delete external_event", %{conn: conn, user: user, external_event: external_event} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: user.id, current_user_type: :client})

      conn = delete conn, external_event_path(conn, :delete, external_event.id)
      assert json_response(conn, 401)
    end

    test "does not allow owner to delete external_event that's not his", %{conn: conn, owner_2: owner_2, external_event: external_event} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: owner_2.id, current_user_type: :owner})

      conn = delete conn, external_event_path(conn, :delete, external_event.id)
      assert json_response(conn, 401)
    end
  end

  defp sign_owner_in(%{conn: conn}) do
    owner = insert(:owner)
    conn_with_signed_owner = Plug.Test.init_test_session(conn, %{current_user_id: owner.id, current_user_type: :owner})

    {:ok, conn: conn_with_signed_owner}
  end

  defp get_invalid_attrs() do
    string_params_for(:external_event)
    |> Enum.map(fn {k, _} -> {k, nil} end)
    |> Map.new()
  end
end
