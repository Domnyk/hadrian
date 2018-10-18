defmodule HadrianWeb.Api.SportComplexControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Repo
  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex

  setup %{conn: conn} do
    sport_complex = insert(:sport_complex)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), sport_complex: sport_complex}
  end

  describe "index" do
    test "returns all sport complexes", %{conn: conn, sport_complex: %SportComplex{id: id, name: name}} do
      conn = get conn, sport_complex_path(conn, :index)

      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      assert [%{"id" => ^id, "name" => ^name}] = resp["data"]["sport_complexes"]
    end
  end

  describe "create" do
    test "when no errors occured inserts new sport complex into DB", %{conn: conn} do
      params = build(:sport_complex_params)

      conn = post conn, sport_complex_path(conn, :create), params
      resp = json_response(conn, 201)
      sport_complex_from_db = Repo.get_by(SportComplex, name: params["data"]["sport_complex"]["name"])
      
      assert %SportComplex{} = sport_complex_from_db
      assert resp["data"]["sport_complex"]["name"] == sport_complex_from_db.name
    end

    test "when no errors occured returns response with status \"ok\" and sport complex data", %{conn: conn} do
      params = build(:sport_complex_params)

      conn = post conn, sport_complex_path(conn, :create), params
      resp = json_response(conn, 201)

      assert resp["status"] == "ok"
      assert Kernel.get_in(resp, ["data", "sport_complex", "id"]) 
      assert resp["data"]["sport_complex"]["name"] == params["data"]["sport_complex"]["name"]
    end
  end

  describe "update" do
    test "renders sport complex when data is valid", %{conn: conn, sport_complex: sport_complex} do
      params = build(:sport_complex_params)
      conn = put conn, sport_complex_path(conn, :update, sport_complex.id), params
      resp = json_response(conn, 200)["data"]["sport_complex"]

      updated_sport_complex = Owners.get_sport_complex!(sport_complex.id)
      assert updated_sport_complex.id == resp["id"]
      assert updated_sport_complex.name == resp["name"]
    end

    test "renders errors when data is invalid", %{conn: conn, sport_complex: sport_complex} do
      params = %{"data" => %{"sport_complex" => %{"name" => nil}}}

      conn = put conn, sport_complex_path(conn, :update, sport_complex.id), params

      resp = json_response(conn, 422)
      assert resp["status"] == "error"
      assert resp["errors"] != %{}
    end
  end

  describe "delete" do
    test "deletes chosen sport complex", %{conn: conn} do
      sport_complex = insert(:sport_complex)

      conn = delete conn, sport_complex_path(conn, :delete, sport_complex.id)

      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_complex!(sport_complex.id) end
    end

    test "returns error when such sport complex does not exist", %{conn: conn} do
      non_existing_id_of_sport_complex = -1

      conn = delete conn, sport_complex_path(conn, :delete, non_existing_id_of_sport_complex)

      assert response(conn, 404)
    end
  end
end