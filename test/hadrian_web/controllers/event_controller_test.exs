defmodule HadrianWeb.EventControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Activities

  @create_attrs %{duration_of_joining_phase: %{months: "1", days: "1", secs: "1"}, 
                  duration_of_paying_phase: %{months: "1", days: "1", secs: "1"}, max_num_of_participants: 42, 
                  min_num_of_participants: 42, time_block_id: 23}
  @update_attrs %{duration_of_joining_phase: %{months: "1", days: "1", secs: "1"}, 
                  duration_of_paying_phase: %{months: "1", days: "1", secs: "1"}, max_num_of_participants: 47, 
                  min_num_of_participants: 45, time_block_id: 25}
  @invalid_attrs %{duration_of_joining_phase: nil, duration_of_paying_phase: nil, max_num_of_participants: nil, min_num_of_participants: nil}

  def fixture(:event) do
    {:ok, event} = Activities.create_event(@create_attrs)
    event
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get conn, event_path(conn, :new)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      insert(:time_block, id: @create_attrs.time_block_id)
      
      conn = post conn, event_path(conn, :create), event: @create_attrs
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == event_path(conn, :show, id)

      conn = get conn, event_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:insert_time_block_and_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get conn, event_path(conn, :edit, event)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup do
      insert(:time_block, id: @create_attrs.time_block_id)
      insert(:time_block, id: @update_attrs.time_block_id)

      event = insert(:event)
      {:ok, event: event}
    end

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert redirected_to(conn) == event_path(conn, :show, event)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:insert_time_block_and_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert redirected_to(conn) == event_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp insert_time_block_and_event(_) do
    insert(:time_block, id: @create_attrs.time_block_id)

    event = insert(:event)
    {:ok, event: event}
  end
end
