defmodule HadrianWeb.Api.SportArenaControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena
  alias Hadrian.Repo

  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    [owner, owner_2] = insert_pair(:complexes_owner)
    sport_complex = insert(:sport_complex, complexes_owner_id: owner.id)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    sport_arena = insert(:sport_arena, sport_object_id: sport_object.id)
    football = insert(:sport_discipline)
    basketball = insert(:sport_discipline, name: "Basketball")
    volleyball = insert(:sport_discipline, name: "Volleyball")
    sport_disciplines = [football, basketball, volleyball]
    sport_disciplines_ids = Enum.map(sport_disciplines, & &1.id)
    sport_disciplines_as_map = Enum.map(sport_disciplines, &%{"id" => &1.id, "name" => &1.name})
    conn = Plug.Test.init_test_session(conn, %{current_user_id: owner.id, current_user_type: :owner})

    {
      :ok, conn: put_req_header(conn, "accept", "application/json"), sport_complex: sport_complex,
      sport_object: sport_object,
      sport_arena: sport_arena,
      sport_disciplines: sport_disciplines,
      sport_disciplines_ids: sport_disciplines_ids,
      sport_disciplines_as_map: sport_disciplines_as_map,
      owner_2: owner_2
    }
  end

  describe "index" do
    test "lists all sport_arenas in sport complex", %{conn: conn, sport_arena: %SportArena{id: id, name: name},
                                                      sport_object: sport_object, sport_disciplines: sport_disciplines,
                                                      sport_disciplines_as_map: sport_disciplines_as_map,
                                                      sport_complex: _} do
      insert_sport_disciplines_in_sport_arena(id, sport_disciplines)
      conn = get conn, sport_object_sport_arena_path(conn, :index, sport_object.id)
      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      assert [%{"id" => ^id, "name" => ^name, "sport_disciplines" => ^sport_disciplines_as_map}] = resp["data"]["sport_arenas"]
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
    setup [:sign_owner_in]

    test "renders sport arena when data is valid", %{conn: conn, sport_complex: _, sport_object: sport_object,
                                                     sport_disciplines_ids: sport_disciplines_ids,
                                                     sport_disciplines_as_map: sport_disciplines_as_map} do
      params = build(:sport_arena_params)
               |> Kernel.put_in(["data", "sport_arena", "sport_object_id"], sport_object.id)
               |> Kernel.put_in(["data", "sport_arena", "sport_disciplines"], sport_disciplines_ids)

      conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
      resp = json_response(conn, 201)["data"]["sport_arena"]
      sport_arena_from_db = Repo.get_by(SportArena, name: resp["name"])

      assert resp["name"] == sport_arena_from_db.name
      assert resp["sport_disciplines"] == sport_disciplines_as_map
    end

    test "renders errors when data is invalid", %{conn: conn, sport_complex: _, sport_object: sport_object} do
     params = %{ data: %{ sport_arena: @invalid_attrs }}
     conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
     resp = json_response(conn, 422)

     assert resp != %{}
    end

    test "client can't create arena", %{conn: conn, sport_object: sport_object} do
      conn = sign_client_in(conn)
      params = %{ data: %{ sport_arena: @invalid_attrs }}
      conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params

      assert json_response(conn, 401)
    end
  end

  describe "update sport arena" do
    alias Hadrian.Owners.SportDiscipline

    test "renders sport arena when data is valid", %{conn: conn, sport_complex: _, sport_object: _,
                                                     sport_arena: sport_arena,
                                                     sport_disciplines_ids: sport_disciplines_ids} do
      [updated_sport_discipline_id | _] = sport_disciplines_ids
      updated_name = "Some updated name"
      conn = put conn, sport_arena_path(conn, :update, sport_arena.id), build_params(updated_sport_discipline_id, updated_name)
      json_response(conn, 200)

      updated_sport_arena = Owners.get_sport_arena!(sport_arena.id) |> Repo.preload(:sport_disciplines)
      assert updated_sport_arena.id == sport_arena.id
      assert updated_sport_arena.name == updated_name
      assert [Hadrian.Repo.get(SportDiscipline, updated_sport_discipline_id)] == updated_sport_arena.sport_disciplines
    end

    test "renders errors when data is invalid", %{conn: conn, sport_arena: sport_arena} do
      conn = put conn, sport_arena_path(conn, :update, sport_arena.id), data: %{sport_arena: @invalid_attrs}
      resp = json_response(conn, 422)

      assert resp != %{}
    end

    test "client can't update arena", %{conn: conn, sport_arena: sport_arena} do
      conn = sign_client_in(conn)
      conn = put conn, sport_arena_path(conn, :update, sport_arena), data: %{sport_arena: @invalid_attrs}

      assert json_response(conn, 401)
    end

    test "owner can't update arena that's not his", %{conn: conn, sport_arena: sport_arena, owner_2: owner_2} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: owner_2.id, current_user_type: :owner})
      conn = put conn, sport_arena_path(conn, :update, sport_arena), data: %{sport_arena: @invalid_attrs}

      assert json_response(conn, 401)
    end

    defp build_params(sport_disciplines_ids, name) do
      build(:sport_arena_params)
      |> Kernel.put_in(["data", "sport_arena", "name"], name)
      |> Kernel.put_in(["data", "sport_arena", "sport_disciplines"], [sport_disciplines_ids])
    end
  end
  
  describe "delete sport_arena" do
    test "deletes chosen sport_arena", %{conn: conn, sport_arena: sport_arena} do
      conn = delete conn, sport_arena_path(conn, :delete, sport_arena)

      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_arena!(sport_arena.id) end
    end

    test "client can't delete arena", %{conn: conn, sport_arena: sport_arena} do
      conn = sign_client_in(conn)
      conn = delete conn, sport_arena_path(conn, :delete, sport_arena)

      assert json_response(conn, 401)
    end

    test "owner can't delete arena that's not his", %{conn: conn, sport_arena: sport_arena, owner_2: owner_2} do
      conn = Plug.Test.init_test_session(conn, %{current_user_id: owner_2.id, current_user_type: :owner})
      conn = delete conn, sport_arena_path(conn, :delete, sport_arena)

      assert json_response(conn, 401)
    end
  end

  defp sign_owner_in(%{conn: conn}) do
    owner = insert(:owner)
    conn_with_signed_owner = Plug.Test.init_test_session(conn, %{current_user_id: owner.id, current_user_type: :owner})

    {:ok, conn: conn_with_signed_owner}
  end

  defp sign_client_in(conn) do
    client = insert(:user)
    conn_with_signed_client = Plug.Test.init_test_session(conn, %{current_user_id: client.id, current_user_type: :client})

    conn_with_signed_client
  end
end
