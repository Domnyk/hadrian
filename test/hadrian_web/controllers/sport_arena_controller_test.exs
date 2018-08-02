defmodule HadrianWeb.SportArenaControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners

  @create_attrs %{name: "some name", sport_object_id: 23, type: "some type"}
  @update_attrs %{name: "some updated name", sport_object_id: 24, type: "some updated type"}
  @invalid_attrs %{name: nil, sport_object_id: nil, type: nil}

  describe "index" do
    test "lists all sport_arenas", %{conn: conn} do
      conn = get conn, sport_arena_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Sport arenas"
    end
  end

  describe "new sport_arena" do
    test "renders form", %{conn: conn} do
      conn = get conn, sport_arena_path(conn, :new)
      assert html_response(conn, 200) =~ "New Sport arena"
    end
  end

  describe "create sport_arena" do
    test "redirects to show when data is valid", %{conn: conn} do
      insert(:sport_object, id: @create_attrs.sport_object_id)

      conn = post conn, sport_arena_path(conn, :create), sport_arena: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == sport_arena_path(conn, :show, id)

      conn = get conn, sport_arena_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Sport arena"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, sport_arena_path(conn, :create), sport_arena: @invalid_attrs
      assert html_response(conn, 200) =~ "New Sport arena"
    end
  end

  describe "edit sport_arena" do
    setup do
      insert(:sport_object, id: @create_attrs.sport_object_id)

      sport_arena = insert(:sport_arena)
      {:ok, sport_arena: sport_arena}
    end

    test "renders form for editing chosen sport_arena", %{conn: conn, sport_arena: sport_arena} do
      conn = get conn, sport_arena_path(conn, :edit, sport_arena)
      assert html_response(conn, 200) =~ "Edit Sport arena"
    end
  end

  describe "update sport_arena" do
    setup do
      insert(:sport_object, id: @create_attrs.sport_object_id)
      insert(:sport_object, id: @update_attrs.sport_object_id)

      sport_arena = insert(:sport_arena)
      {:ok, sport_arena: sport_arena}
    end

    test "redirects when data is valid", %{conn: conn, sport_arena: sport_arena} do
      conn = put conn, sport_arena_path(conn, :update, sport_arena), sport_arena: @update_attrs
      assert redirected_to(conn) == sport_arena_path(conn, :show, sport_arena)

      conn = get conn, sport_arena_path(conn, :show, sport_arena)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, sport_arena: sport_arena} do
      conn = put conn, sport_arena_path(conn, :update, sport_arena), sport_arena: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Sport arena"
    end
  end

  describe "delete sport_arena" do
    setup do
      insert(:sport_object, id: @create_attrs.sport_object_id)

      sport_arena = insert(:sport_arena)
      {:ok, sport_arena: sport_arena}
    end
    
    test "deletes chosen sport_arena", %{conn: conn, sport_arena: sport_arena} do
      conn = delete conn, sport_arena_path(conn, :delete, sport_arena)
      assert redirected_to(conn) == sport_arena_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, sport_arena_path(conn, :show, sport_arena)
      end
    end
  end
end
