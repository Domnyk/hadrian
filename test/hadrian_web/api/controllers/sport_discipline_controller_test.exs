defmodule HadrianWeb.SportDisciplineControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportDiscipline

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "when no url params present returns all sport disciplines", %{conn: conn} do
      football = insert(:sport_discipline)
      basketball = insert(:sport_discipline, name: "Basketball")

      conn = get conn, sport_discipline_path(conn, :index)
      resp = json_response(conn, 200)
      [football_from_resp | [basketball_from_resp | _]] = resp["data"]["sport_disciplines"]

      assert resp["status"] == "ok"
      assert football_from_resp["name"] == football.name
      assert basketball_from_resp["name"] == basketball.name
    end
  end
end