defmodule HadrianWeb.TimeBlockControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners

  @create_attrs %{daily_schedule_id: 42, end_hour: ~T[15:00:00.000000], start_hour: ~T[14:00:00.000000]}
  @update_attrs %{daily_schedule_id: 43, end_hour: ~T[16:01:01.000000], start_hour: ~T[15:01:01.000000]}
  @invalid_attrs %{daily_schedule_id: nil, end_hour: nil, start_hour: nil}

  def fixture(:time_block) do
    {:ok, time_block} = Owners.create_time_block(@create_attrs)
    time_block
  end

  describe "index" do
    test "lists all time_blocks", %{conn: conn} do
      conn = get conn, time_block_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Time blocks"
    end
  end

  describe "new time_block" do
    test "renders form", %{conn: conn} do
      conn = get conn, time_block_path(conn, :new)
      assert html_response(conn, 200) =~ "New Time block"
    end
  end

  describe "create time_block" do
    test "redirects to show when data is valid", %{conn: conn} do
      insert(:daily_schedule, id: @create_attrs.daily_schedule_id)

      conn = post conn, time_block_path(conn, :create), time_block: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == time_block_path(conn, :show, id)

      conn = get conn, time_block_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Time block"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, time_block_path(conn, :create), time_block: @invalid_attrs
      assert html_response(conn, 200) =~ "New Time block"
    end
  end

  describe "edit time_block" do
    setup [:insert_daily_schedule_and_time_block]

    test "renders form for editing chosen time_block", %{conn: conn, time_block: time_block} do
      conn = get conn, time_block_path(conn, :edit, time_block)
      assert html_response(conn, 200) =~ "Edit Time block"
    end
  end

  describe "update time_block" do
    setup do
      insert(:daily_schedule, id: @create_attrs.daily_schedule_id)
      insert(:daily_schedule, id: @update_attrs.daily_schedule_id)
      
      time_block = insert(:time_block)
      {:ok, time_block: time_block}
    end

    test "redirects when data is valid", %{conn: conn, time_block: time_block} do
      conn = put conn, time_block_path(conn, :update, time_block), time_block: @update_attrs
      assert redirected_to(conn) == time_block_path(conn, :show, time_block)

      conn = get conn, time_block_path(conn, :show, time_block)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, time_block: time_block} do
      conn = put conn, time_block_path(conn, :update, time_block), time_block: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Time block"
    end
  end

  describe "delete time_block" do
    setup [:insert_daily_schedule_and_time_block]

    test "deletes chosen time_block", %{conn: conn, time_block: time_block} do
      conn = delete conn, time_block_path(conn, :delete, time_block)
      assert redirected_to(conn) == time_block_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, time_block_path(conn, :show, time_block)
      end
    end
  end

  defp insert_daily_schedule_and_time_block(_) do
    insert(:daily_schedule, id: @create_attrs.daily_schedule_id)

    time_block = insert(:time_block)
    {:ok, time_block: time_block}
  end
end
