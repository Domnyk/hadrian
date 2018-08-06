defmodule HadrianWeb.DailyScheduleControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners

  @create_attrs %{schedule_day: ~D[2010-04-17], sport_arena_id: 42}
  @update_attrs %{schedule_day: ~D[2011-05-18], sport_arena_id: 43}
  @invalid_attrs %{schedule_day: nil, sport_arena_id: nil}

  describe "index" do
    test "lists all daily_schedules", %{conn: conn} do
      conn = get conn, daily_schedule_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Daily schedules"
    end
  end

  describe "new daily_schedule" do
    test "renders form", %{conn: conn} do
      conn = get conn, daily_schedule_path(conn, :new)
      assert html_response(conn, 200) =~ "New Daily schedule"
    end
  end

  describe "create daily_schedule" do
    test "redirects to show when data is valid", %{conn: conn} do
      insert(:sport_arena, id: @create_attrs.sport_arena_id)
      
      conn = post conn, daily_schedule_path(conn, :create), daily_schedule: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == daily_schedule_path(conn, :show, id)

      conn = get conn, daily_schedule_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Daily schedule"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, daily_schedule_path(conn, :create), daily_schedule: @invalid_attrs
      assert html_response(conn, 200) =~ "New Daily schedule"
    end
  end

  describe "edit daily_schedule" do
    setup [:insert_sport_arena_and_daily_schedule]

    test "renders form for editing chosen daily_schedule", %{conn: conn, daily_schedule: daily_schedule} do
      conn = get conn, daily_schedule_path(conn, :edit, daily_schedule)
      assert html_response(conn, 200) =~ "Edit Daily schedule"
    end
  end

  describe "update daily_schedule" do
    setup do
      insert(:sport_arena, id: @create_attrs.sport_arena_id)
      insert(:sport_arena, id: @update_attrs.sport_arena_id)

      daily_schedule = insert(:daily_schedule)
      {:ok, daily_schedule: daily_schedule}
    end

    test "redirects when data is valid", %{conn: conn, daily_schedule: daily_schedule} do
      conn = put conn, daily_schedule_path(conn, :update, daily_schedule), daily_schedule: @update_attrs
      assert redirected_to(conn) == daily_schedule_path(conn, :show, daily_schedule)

      conn = get conn, daily_schedule_path(conn, :show, daily_schedule)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, daily_schedule: daily_schedule} do
      conn = put conn, daily_schedule_path(conn, :update, daily_schedule), daily_schedule: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Daily schedule"
    end
  end

  describe "delete daily_schedule" do
    setup [:insert_sport_arena_and_daily_schedule]

    test "deletes chosen daily_schedule", %{conn: conn, daily_schedule: daily_schedule} do
      conn = delete conn, daily_schedule_path(conn, :delete, daily_schedule)
      assert redirected_to(conn) == daily_schedule_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, daily_schedule_path(conn, :show, daily_schedule)
      end
    end
  end

  defp insert_sport_arena_and_daily_schedule(_) do
    insert(:sport_arena, id: @create_attrs.sport_arena_id)

    daily_schedule = insert(:daily_schedule)
    {:ok, daily_schedule: daily_schedule}    
  end
end
