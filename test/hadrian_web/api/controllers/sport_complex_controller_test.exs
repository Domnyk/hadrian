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
end