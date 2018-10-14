defmodule HadrianWeb.SportObjectControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners.SportObject

  @status_code_to_assert 200

  describe "index" do
    # TODO: This is verbose
    test "returns all sport objects", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      num_of_sport_objects_inserted = 2
      sport_object_1 = insert(:sport_object, sport_complex_id: sport_complex.id)
      sport_object_2 = insert(:sport_object, sport_complex_id: sport_complex.id)

      conn = get conn, sport_object_path(conn, :index)
      resp = json_response(conn, @status_code_to_assert)
      sport_objects_array = resp["data"]["sport_objects"]
      sport_object_from_resp_1 = Enum.at(sport_objects_array, 0)
      sport_object_from_resp_2 = Enum.at(sport_objects_array, 1)

      assert are_sport_objects_the_same(sport_object_1, sport_object_from_resp_1)
      assert are_sport_objects_the_same(sport_object_2, sport_object_from_resp_2)
      assert length(sport_objects_array) == num_of_sport_objects_inserted
    end

    defp are_sport_objects_the_same(%SportObject{} = sport_object, sport_object_in_json_format) do
      assert sport_object_in_json_format["id"] == sport_object.id
      assert sport_object_in_json_format["name"] == sport_object.name
      assert sport_object_in_json_format["geo_coordinates"]["latitude"] == sport_object.geo_coordinates.latitude
      assert sport_object_in_json_format["geo_coordinates"]["longitude"] == sport_object.geo_coordinates.longitude
      assert sport_object_in_json_format["booking_margin"]["months"] == sport_object.booking_margin.months
      assert sport_object_in_json_format["booking_margin"]["days"] == sport_object.booking_margin.days
      assert sport_object_in_json_format["booking_margin"]["secs"] == sport_object.booking_margin.secs
    end
  end

  describe "index with sport_complex_id in params" do
    test "returns sport objects in sport complex", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      sport_complex_wrong = insert(:sport_complex)
      num_of_desired_sport_objects = 2
      sport_object_1 = insert(:sport_object, sport_complex_id: sport_complex.id)
      sport_object_2 = insert(:sport_object, sport_complex_id: sport_complex.id)
      insert(:sport_object, sport_complex_id: sport_complex_wrong.id)


      conn = get conn, sport_complex_sport_object_path(conn, :index, sport_complex.id)
      resp = json_response(conn, @status_code_to_assert)
      sport_objects_array = resp["data"]["sport_objects"]
      sport_object_from_resp_2 = Enum.at(sport_objects_array, 0)
      sport_object_from_resp_1 = Enum.at(sport_objects_array, 1)

      assert are_sport_objects_the_same(sport_object_1, sport_object_from_resp_1, :simple)
      assert are_sport_objects_the_same(sport_object_2, sport_object_from_resp_2, :simple)
      assert length(sport_objects_array) == num_of_desired_sport_objects
    end

    defp are_sport_objects_the_same(%SportObject{} = sport_object, sport_object_in_json_format, :simple) do
      assert sport_object_in_json_format["name"] == sport_object.name
      assert sport_object_in_json_format["id"] == sport_object.id
    end
  end

  describe "create" do
    test "when data is valid it should create sport object", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      request_data = build(:sport_object_params)
      |> Kernel.put_in(["data", "sport_object", "sport_complex_id"], sport_complex.id)
      sport_object_from_req = request_data["data"]["sport_object"]

      conn = post conn, sport_object_path(conn, :create), request_data
      resp = json_response(conn, @status_code_to_assert)
      sport_object_from_res = resp["data"]["sport_object"]

      assert resp["status"] == "ok"
      assert sport_object_from_res["name"] == sport_object_from_req["name"]
      assert sport_object_from_res["geo_coordinates"] == sport_object_from_req["geo_coordinates"]
      assert sport_object_from_res["sport_complex_id"] == sport_object_from_req["sport_complex_id"]
      assert sport_object_from_res["booking_margin"] == sport_object_from_req["booking_margin"]
    end

    test "when data is not valid it should return errors", %{conn: conn} do
      sport_complex = insert(:sport_complex)
      invalid_request_data = build(:sport_object_params)
      |> Kernel.put_in(["data", "sport_object", "sport_complex_id"], sport_complex.id)
      |> Kernel.put_in(["data", "sport_object", "geo_coordinates"], nil)

      conn = post conn, sport_object_path(conn, :create), invalid_request_data
      resp = json_response(conn, @status_code_to_assert)

      assert resp["errors"]
      assert resp["status"] == "error"
      assert resp["errors"]["geo_coordinates"] == ["can't be blank"]
    end
  end
end