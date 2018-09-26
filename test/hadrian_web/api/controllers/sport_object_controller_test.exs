defmodule HadrianWeb.SportObjectControllerTest do
  use HadrianWeb.ConnCase

  describe "index" do
    test "returns all sport objects" do
      assert false
    end
  end

  describe "create" do
    test "when data is valid it should create sport object", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      sport_object_params = build(:sport_object)
      |> Map.from_struct
      |> Map.put(:sport_complex_id, sport_complex.id)

      conn = post conn, sport_object_path(conn, :create), sport_object_params
      resp = json_response(conn, 200)

      assert resp["status"] == "ok"
      assert resp["data"]["sport_object"] == sport_object_params
    end

    test "when data is not valid it should return errors", %{conn: conn} do
      assert false
    end
  end
end