defmodule HadrianWeb.Api.SportArenaControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena
  alias Hadrian.Repo

  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    sport_complex = insert(:sport_complex)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id)
    football = insert(:sport_discipline)
    basketball = insert(:sport_discipline, name: "Basketball")
    volleyball = insert(:sport_discipline, name: "Volleyball")
    sport_disciplines = [football, basketball, volleyball]
    sport_disciplines_as_maps = Enum.map(sport_disciplines, &(%{"id" => &1.id, "name" => &1.name}))

    {
      :ok, conn: put_req_header(conn, "accept", "application/json"), sport_complex: sport_complex,
      sport_object: sport_object,
      sport_arena: sport_arena,
      sport_disciplines: sport_disciplines,
      sport_disciplines_as_maps: sport_disciplines_as_maps
    }
  end

  describe "index" do
    test "lists all sport_arenas in sport complex", %{conn: conn, sport_arena: %SportArena{id: id, name: name},
                                                      sport_object: sport_object, sport_disciplines: sport_disciplines,
                                                      sport_disciplines_as_maps: sport_disciplines_as_maps,
                                                      sport_complex: _} do
      insert_sport_disciplines_in_sport_arena(id, sport_disciplines)
      conn = get conn, sport_object_sport_arena_path(conn, :index, sport_object.id)
      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      assert [%{"id" => ^id, "name" => ^name, "sport_disciplines" => ^sport_disciplines_as_maps}] = resp["data"]["sport_arenas"]
    end

    defp insert_sport_disciplines_in_sport_arena(sport_arena_id, sport_disciplines) do
      sport_arena_from_db =
        Repo.get!(SportArena, sport_arena_id)
        |> Repo.preload(:sport_disciplines)

      Ecto.Changeset.put_assoc(Owners.change_sport_arena(sport_arena_from_db), :sport_disciplines, sport_disciplines)
      |> Hadrian.Repo.update!
    end
  end

  describe "create sport_arena" do
    test "renders sport arena when data is valid", %{conn: conn, sport_complex: _, sport_object: sport_object,
                                                     sport_disciplines_as_maps: sport_disciplines_as_maps} do
      params = build(:sport_arena_params)
               |> Kernel.put_in(["data", "sport_arena", "sport_object_id"], sport_object.id)
               |> Kernel.put_in(["data", "sport_arena", "sport_disciplines"], sport_disciplines_as_maps)

      conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
      resp = json_response(conn, 201)["data"]["sport_arena"]
      sport_arena_from_db = Repo.get_by(SportArena, name: resp["name"])

      assert resp["name"] == sport_arena_from_db.name
      assert resp["sport_disciplines"] == sport_disciplines_as_maps
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
    alias Hadrian.Owners.SportDiscipline

    test "renders sport arena when data is valid", %{conn: conn, sport_complex: _, sport_object: _,
                                                     sport_arena: sport_arena,
                                                     sport_disciplines_as_maps: sport_disciplines_as_maps} do
      [%{"id" => id, "name" => name} = updated_sport_discipline | _] = sport_disciplines_as_maps
      updated_name = "Some updated name"
      conn = put conn, sport_arena_path(conn, :update, sport_arena.id), build_params(updated_sport_discipline, updated_name)
      json_response(conn, 200)

      updated_sport_arena = Owners.get_sport_arena!(sport_arena.id) |> Repo.preload(:sport_disciplines)
      assert updated_sport_arena.id == sport_arena.id
      assert updated_sport_arena.name == updated_name
      assert [%SportDiscipline{id: ^id, name: ^name}] = updated_sport_arena.sport_disciplines
    end

    test "renders errors when data is invalid", %{conn: conn, sport_complex: _, sport_object: _,
                                                  sport_arena: sport_arena} do
      conn = put conn, sport_arena_path(conn, :update, sport_arena), data: %{sport_arena: @invalid_attrs}
      resp = json_response(conn, 422)
      assert resp["status"] == "error"
      assert resp["errors"] != %{}
    end

    defp build_params(sport_disciplines, name) do
      build(:sport_arena_params)
      |> Kernel.put_in(["data", "sport_arena", "name"], name)
      |> Kernel.put_in(["data", "sport_arena", "sport_disciplines"], [sport_disciplines])
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
