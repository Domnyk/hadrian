defmodule HadrianWeb.Api.SportComplexControllerTest do
  use HadrianWeb.ConnCase

  describe "index" do
    test "when no params present returns all sport complexes", %{conn: conn} do
      sport_complex_1 = insert(:sport_complex)
      sport_complex_2 = insert(:sport_complex)

      conn = get conn, sport_complex_path(conn, :index)
      resp = json_response(conn, 200)
      [sport_complex_json_1 | [sport_complex_json_2 | _]] = resp["data"]

      assert resp["status"] == "ok"
      assert sport_complex_json_1["name"] == sport_complex_1.name
      assert sport_complex_json_1["id"] == sport_complex_1.id
      assert sport_complex_json_2["name"] == sport_complex_2.name
      assert sport_complex_json_2["id"] == sport_complex_2.id
    end
  end

  describe "create" do
    alias Hadrian.Repo
    alias Hadrian.Owners.SportComplex
    
    test "when no errors occured inserts new sport complex into DB", %{conn: conn} do
      params = build(:sport_complex_params)

      conn = post conn, sport_complex_path(conn, :create), params
      resp = json_response(conn, 200)
      sport_complex_from_db = Repo.get_by(SportComplex, name: params["data"]["sport_complex"]["name"])
      
      assert %SportComplex{} = sport_complex_from_db
      assert resp["data"]["sport_complex"]["name"] == sport_complex_from_db.name
    end

    test "when no errors occured returns response with status \"ok\" and sport complex data", %{conn: conn} do
      params = build(:sport_complex_params)

      conn = post conn, sport_complex_path(conn, :create), params
      resp = json_response(conn, 200)

      assert resp["status"] == "ok"
      assert Kernel.get_in(resp, ["data", "sport_complex", "id"]) 
      assert resp["data"]["sport_complex"]["name"] == params["data"]["sport_complex"]["name"]
    end
  end
end