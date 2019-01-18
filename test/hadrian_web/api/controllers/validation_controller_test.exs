defmodule HadrianWeb.ValidationControllerTest do
  use HadrianWeb.ConnCase

  describe "validate complex" do
    test "returns true when name is unique", %{conn: conn} do
      conn = post conn, validation_path(conn, :validate_complex), %{"name" => "Unique name"}

      resp = json_response(conn, 200)
      assert resp["valid"]
    end

    test "returns false when name is not unique", %{conn: conn} do
      name = "Non unique name"
      insert(:sport_complex, name: name)
      conn = post conn, validation_path(conn, :validate_complex), %{"name" => name}

      resp = json_response(conn, 200)
      refute resp["valid"]
    end
  end

end
