defmodule HadrianWeb.Api.SportArenaControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena
  alias Hadrian.Repo

  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil, type: nil}

  setup %{conn: conn} do
    sport_complex = insert(:sport_complex)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id)

    {
      :ok, conn: put_req_header(conn, "accept", "application/json"), sport_complex: sport_complex,
      sport_object: sport_object,
      sport_arena: sport_arena
    }
  end

  describe "index" do
    test "lists all sport_arenas in sport complex", %{conn: conn, sport_arena: %SportArena{id: id, name: name},
                                                      sport_object: sport_object, sport_complex: _} do
      conn = get conn, sport_object_sport_arena_path(conn, :index, sport_object.id)
      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      assert [%{"id" => ^id, "name" => ^name}] = resp["data"]["sport_arenas"]
    end
  end

  describe "create sport_arena" do
    test "renders sport arena when data is valid", %{conn: conn, sport_complex: _, sport_object: sport_object} do
      params = build(:sport_arena_params)
               |> Kernel.put_in(["data", "sport_arena", "sport_object_id"], sport_object.id)

      conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
      resp = json_response(conn, 201)["data"]["sport_arena"]
      sport_arena_from_db = Repo.get_by(SportArena, name: resp["name"])

      assert resp["name"] == sport_arena_from_db.name
    end

    test "renders errors when data is invalid", %{conn: conn, sport_complex: _, sport_object: sport_object} do
     params = %{ data: %{ sport_arena: @invalid_attrs }}
     conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
     resp = json_response(conn, 422)
     assert resp["status"] == "error"
     assert resp["errors"] != %{}
    end
  end

  describe "update sport arena" do
    test "renders sport arena when data is valid", %{conn: conn, sport_complex: _, sport_object: _,
                                                     sport_arena: sport_arena} do
      conn = put conn, sport_arena_path(conn, :update, sport_arena.id), sport_arena: @update_attrs
      resp = json_response(conn, 200)["data"]["sport_arena"]

      updated_sport_arena = Owners.get_sport_arena!(sport_arena.id)
      assert updated_sport_arena.id == resp["id"]
      assert updated_sport_arena.name == resp["name"]
    end

    test "renders errors when data is invalid", %{conn: conn, sport_complex: _, sport_object: _,
                                                  sport_arena: sport_arena} do
      conn = put conn, sport_arena_path(conn, :update, sport_arena), sport_arena: @invalid_attrs
      resp = json_response(conn, 422)
      assert resp["status"] == "error"
      assert resp["errors"] != %{}
    end
  end
  
  describe "delete sport_arena" do
    test "deletes chosen sport_arena", %{conn: conn, sport_complex: _, sport_object: _, sport_arena: sport_arena} do
      conn = delete conn, sport_arena_path(conn, :delete, sport_arena)
      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_arena!(sport_arena.id) end
    end
  end
end
