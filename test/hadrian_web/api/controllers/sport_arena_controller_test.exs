defmodule HadrianWeb.Api.SportArenaControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena
  alias Hadrian.Repo

  @create_attrs %{name: "Boisko sportowe"}
  @update_attrs %{name: "some updated name", type: "some updated type"}
  @invalid_attrs %{name: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sport_arenas in sport complex", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
      conn = get conn, sport_object_sport_arena_path(conn, :index, sport_object.id)
      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      assert resp["data"]["sport_arenas"] == []
    end
  end

  describe "create sport_arena" do
    test "renders sport arena when data is valid", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
      params = build(:sport_arena_params)
               |> Kernel.put_in(["data", "sport_arena", "sport_object_id"], sport_object.id)

      conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
      resp = json_response(conn, 201)["data"]["sport_arena"]
      sport_arena_from_db = Repo.get_by(SportArena, name: resp["name"])

      assert resp["name"] == sport_arena_from_db.name
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #  sport_complex = insert(:sport_complex)
    #  sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)
    #  params = %{ data: %{ sport_arena: @invalid_attrs }}
    #  conn = post conn, sport_object_sport_arena_path(conn, :create, sport_object.id), params
    #  assert json_response(conn, 422)["errors"] != %{}
    # end
  end
  #
  # describe "update sport_arena" do
  #   setup [:create_sport_arena]
  #
  #   test "renders sport_arena when data is valid", %{conn: conn, sport_arena: %SportArena{id: id} = sport_arena} do
  #     conn = put conn, sport_arena_path(conn, :update, sport_arena), sport_arena: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]
  #
  #     conn = get conn, sport_arena_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "name" => "some updated name",
  #       "type" => "some updated type"}
  #   end
  #
  #   test "renders errors when data is invalid", %{conn: conn, sport_arena: sport_arena} do
  #     conn = put conn, sport_arena_path(conn, :update, sport_arena), sport_arena: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end
  #
  # describe "delete sport_arena" do
  #   setup [:create_sport_arena]
  #
  #   test "deletes chosen sport_arena", %{conn: conn, sport_arena: sport_arena} do
  #     conn = delete conn, sport_arena_path(conn, :delete, sport_arena)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, sport_arena_path(conn, :show, sport_arena)
  #     end
  #   end
  # end

  defp create_sport_arena(_) do
    sport_arena = fixture(:sport_arena)
    {:ok, sport_arena: sport_arena}
  end
end
