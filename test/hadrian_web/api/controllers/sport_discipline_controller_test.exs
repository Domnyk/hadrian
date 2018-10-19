defmodule HadrianWeb.SportDisciplineControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners.SportDiscipline

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "when no url params present returns all sport disciplines", %{conn: conn} do
      %SportDiscipline{id: id, name: name} = insert(:sport_discipline)

      conn = get conn, sport_discipline_path(conn, :index)

      resp = json_response(conn, 200)
      assert resp["status"] == "ok"
      assert [%{"id" => ^id, "name" => ^name}] = resp["data"]["sport_disciplines"]
    end
  end
end