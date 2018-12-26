defmodule HadrianWeb.Api.ComplexControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex

  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    owner = insert(:complexes_owner)
    complex = insert(:sport_complex)
    conn = Plug.Test.init_test_session(conn, %{current_user_id: owner.id})

    {:ok, conn: put_req_header(conn, "accept", "application/json"), complex: complex, owner: owner}
  end

  describe "index" do
    test "returns all complexes", %{conn: conn, complex: %SportComplex{id: id, name: name}} do
      conn = get conn, complex_path(conn, :index)

      assert [%{"id" => ^id, "name" => ^name}] = json_response(conn, 200)
    end
  end

  describe "create" do
    test "inserts complex", %{conn: conn} do
      attrs = string_params_for(:sport_complex)

      conn = post conn, complex_path(conn, :create), attrs
      %{"id" => id} = resp = json_response(conn, 201)

      assert are_equal(Owners.get_sport_complex!(id), resp)
    end

    test "returns invalid fields", %{conn: conn} do
      conn = post conn, complex_path(conn, :create), @invalid_attrs
      resp = json_response(conn, 422)

      assert resp["name"] == ["can't be blank"]
    end
  end

  describe "update" do
    test "updates complex", %{conn: conn, complex: sport_complex} do
      attrs = string_params_for(:sport_complex)

      conn = put conn, complex_path(conn, :update, sport_complex.id), attrs
      %{"id" => id} = resp = json_response(conn, 200)

      assert are_equal(Owners.get_sport_complex!(id), resp)
    end

    test "returns invalid fields", %{conn: conn, complex: complex} do
      conn = put conn, complex_path(conn, :update, complex.id), @invalid_attrs
      resp = json_response(conn, 422)

      assert resp["name"] == ["can't be blank"]
    end
  end

  describe "delete" do
    test "deletes chosen sport complex", %{conn: conn, complex: complex} do
      conn = delete conn, complex_path(conn, :delete, complex.id)
      %{"id" => id} = resp = json_response(conn, 200)

      assert are_equal(complex, resp)
      assert_raise Ecto.NoResultsError, fn -> Owners.get_sport_complex!(id) end
    end

    test "returns error when such sport complex does not exist", %{conn: conn} do
      non_existing_id_of_sport_complex = -1

      conn = delete conn, complex_path(conn, :delete, non_existing_id_of_sport_complex)

      assert response(conn, 404)
    end
  end

  defp are_equal(complex = %SportComplex{}, complex_map) when is_map(complex_map) do
    assert complex.id == complex_map["id"]
    assert complex.name == complex_map["name"]
  end
end