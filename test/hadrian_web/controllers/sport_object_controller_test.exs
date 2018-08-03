defmodule HadrianWeb.SportObjectControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners

  @create_attrs %{"latitude" => "10.5", "longitude" => "9.5", "name" => "some name", "sport_complex_id" => "23", 
                  "booking_margin_months" => "2", "booking_margin_days" => "5"}
  @update_attrs %{"latitude" => "11.5", "longitude" => "8.7", "name" => "some updated name", "sport_complex_id" => "24",
                  "booking_margin_months" => "3", "booking_margin_days" => "4"}
  @invalid_attrs %{"latitude" => nil, "longitude" => nil, "name" => nil, "booking_margin_months" => nil, "booking_margin_days" => nil}

  describe "index" do
    test "lists all sport_objects", %{conn: conn} do
      conn = get conn, sport_object_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Sport objects"
    end
  end

  describe "new sport_object" do
    test "renders form", %{conn: conn} do
      conn = get conn, sport_object_path(conn, :new)
      assert html_response(conn, 200) =~ "New Sport object"
    end
  end

  describe "create sport_object" do  
    test "redirects to show when data is valid", %{conn: conn} do
      insert(:sport_complex, id: @create_attrs["sport_complex_id"])

      conn = post conn, sport_object_path(conn, :create), sport_object: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == sport_object_path(conn, :show, id)

      conn = get conn, sport_object_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Sport object"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      insert(:sport_complex, id: @invalid_attrs["sport_complex_id"])

      conn = post conn, sport_object_path(conn, :create), sport_object: @invalid_attrs
      assert html_response(conn, 200) =~ "New Sport object"
    end
  end

  describe "edit sport_object" do
    setup do
      insert(:sport_complex, id: @create_attrs["sport_complex_id"])

      sport_object= insert(:sport_object)
      {:ok, sport_object: sport_object}
    end

    test "renders form for editing chosen sport_object", %{conn: conn, sport_object: sport_object} do
      conn = get conn, sport_object_path(conn, :edit, sport_object)
      assert html_response(conn, 200) =~ "Edit Sport object"
    end
  end

  describe "update sport_object" do
    setup do
      insert(:sport_complex, id: @create_attrs["sport_complex_id"])
      insert(:sport_complex, id: @update_attrs["sport_complex_id"])

      sport_object = insert(:sport_object)
      {:ok, sport_object: sport_object}
    end

    test "redirects when data is valid", %{conn: conn, sport_object: sport_object} do
      conn = put conn, sport_object_path(conn, :update, sport_object), sport_object: @update_attrs
      assert redirected_to(conn) == sport_object_path(conn, :show, sport_object)

      conn = get conn, sport_object_path(conn, :show, sport_object)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, sport_object: sport_object} do
      conn = put conn, sport_object_path(conn, :update, sport_object), sport_object: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Sport object"
    end
  end

  describe "delete sport_object" do
    setup do
      insert(:sport_complex, id: @create_attrs["sport_complex_id"])

      sport_object = insert(:sport_object)
      {:ok, sport_object: sport_object}
    end

    test "deletes chosen sport_object", %{conn: conn, sport_object: sport_object} do
      conn = delete conn, sport_object_path(conn, :delete, sport_object)
      assert redirected_to(conn) == sport_object_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, sport_object_path(conn, :show, sport_object)
      end
    end
  end
end