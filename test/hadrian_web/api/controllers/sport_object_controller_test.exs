defmodule HadrianWeb.SportObjectControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject

  setup %{conn: conn} do
    sport_complex = insert(:sport_complex)
    sport_object = insert(:sport_object, sport_complex_id: sport_complex.id)

    {:ok, conn: put_req_header(conn, "accept", "application/json"), sport_complex: sport_complex,
     sport_object: sport_object}
  end

  describe "index" do
    test "returns all sport objects in sport complex", %{conn: conn, sport_complex: sport_complex, sport_object: sport_object} do
      conn = get conn, sport_complex_sport_object_path(conn, :index, sport_complex.id)

      resp = json_response(conn, 200)
      [sport_object_from_resp | _] = resp["data"]["sport_objects"]
      assert are_sport_objects_the_same(sport_object, sport_object_from_resp)
    end

    # TODO: This is verbose
    defp are_sport_objects_the_same(%SportObject{} = sport_object, sport_object_in_json_format) do
      assert sport_object_in_json_format["id"] == sport_object.id
      assert sport_object_in_json_format["name"] == sport_object.name
      assert sport_object_in_json_format["geo_coordinates"]["latitude"] == sport_object.geo_coordinates.latitude
      assert sport_object_in_json_format["geo_coordinates"]["longitude"] == sport_object.geo_coordinates.longitude
      assert sport_object_in_json_format["booking_margin"]["months"] == sport_object.booking_margin.months
      assert sport_object_in_json_format["booking_margin"]["days"] == sport_object.booking_margin.days
      assert sport_object_in_json_format["booking_margin"]["secs"] == sport_object.booking_margin.secs
      assert sport_object_in_json_format["sport_complex_id"] == sport_object.sport_complex_id
    end
  end

  describe "create" do
    test "when data is valid it should create sport object", %{conn: conn, sport_complex: sport_complex} do
      request_data = build(:sport_object_params)
      |> Kernel.put_in(["data", "sport_object", "sport_complex_id"], sport_complex.id)
      sport_object_from_req = request_data["data"]["sport_object"]

      conn = post conn, sport_complex_sport_object_path(conn, :create, sport_complex.id), request_data
      resp = json_response(conn, 201)
      sport_object_from_res = resp["data"]["sport_object"]

      assert resp["status"] == "ok"
      assert sport_object_from_res["name"] == sport_object_from_req["name"]
      assert sport_object_from_res["geo_coordinates"] == sport_object_from_req["geo_coordinates"]
      assert sport_object_from_res["sport_complex_id"] == sport_object_from_req["sport_complex_id"]
      assert sport_object_from_res["booking_margin"] == sport_object_from_req["booking_margin"]
    end

    test "when data is not valid it should return errors", %{conn: conn, sport_complex: sport_complex} do
      invalid_request_data = build(:sport_object_params)
      |> Kernel.put_in(["data", "sport_object", "sport_complex_id"], sport_complex.id)
      |> Kernel.put_in(["data", "sport_object", "geo_coordinates"], nil)

      conn = post conn, sport_complex_sport_object_path(conn, :create, sport_complex.id), invalid_request_data
      resp = json_response(conn, 422)

      assert resp["errors"]
      assert resp["status"] == "error"
      assert resp["errors"]["geo_coordinates"] == ["can't be blank"]
    end
  end

  describe "update" do
    # TODO: This is verbose
    test "renders sport object when data is valid", %{conn: conn, sport_object: sport_object} do
      params = build(:sport_object_params)
               |> Kernel.put_in(["data", "sport_object", "sport_complex_id"], sport_object.sport_complex_id)
      conn = put conn, sport_object_path(conn, :update, sport_object.id), params

      resp = json_response(conn, 200)["data"]["sport_object"]
      updated_sport_object = Owners.get_sport_object!(sport_object.id)
      assert updated_sport_object.geo_coordinates.latitude == resp["geo_coordinates"]["latitude"]
      assert updated_sport_object.geo_coordinates.longitude == resp["geo_coordinates"]["longitude"]
      assert updated_sport_object.name == resp["name"]
      assert updated_sport_object.booking_margin.months == resp["booking_margin"]["months"]
      assert updated_sport_object.booking_margin.days == resp["booking_margin"]["days"]
      assert updated_sport_object.booking_margin.secs == resp["booking_margin"]["secs"]
    end

    test "renders errors when data is invalid", %{conn: conn, sport_object: sport_object} do
      params = %{"data" => %{"sport_object" => %{"name" => nil}}}

      conn = put conn, sport_object_path(conn, :update, sport_object.id), params

      resp = json_response(conn, 422)
      assert resp["status"] == "error"
      assert resp["errors"] != %{}
    end
  end

  describe "delete" do
    test "deletes chosen sport object", %{conn: conn, sport_complex: _, sport_object: sport_object} do
      conn = delete conn, sport_object_path(conn, :delete, sport_object.id)

      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_object!(sport_object.id) end
    end

    test "returns error when such sport object does not exist", %{conn: conn} do
      non_existing_id_of_sport_object = -1

      conn = delete conn, sport_object_path(conn, :delete, non_existing_id_of_sport_object)

      assert response(conn, 404)
    end
  end
end