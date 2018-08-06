defmodule HadrianWeb.SportComplexControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.Owners

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:sport_complex) do
    {:ok, sport_complex} = Owners.create_sport_complex(@create_attrs)
    sport_complex
  end

  describe "index" do
    test "lists all sport_complexes", %{conn: conn} do
      conn = get conn, sport_complex_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Sport complexes"
    end
  end

  describe "new sport_complex" do
    test "renders form", %{conn: conn} do
      conn = get conn, sport_complex_path(conn, :new)
      assert html_response(conn, 200) =~ "New Sport complex"
    end
  end

  describe "create sport_complex" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, sport_complex_path(conn, :create), sport_complex: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == sport_complex_path(conn, :show, id)

      conn = get conn, sport_complex_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Sport complex"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, sport_complex_path(conn, :create), sport_complex: @invalid_attrs
      assert html_response(conn, 200) =~ "New Sport complex"
    end
  end

  describe "edit sport_complex" do
    setup [:create_sport_complex]

    test "renders form for editing chosen sport_complex", %{conn: conn, sport_complex: sport_complex} do
      conn = get conn, sport_complex_path(conn, :edit, sport_complex)
      assert html_response(conn, 200) =~ "Edit Sport complex"
    end
  end

  describe "update sport_complex" do
    setup [:create_sport_complex]

    test "redirects when data is valid", %{conn: conn, sport_complex: sport_complex} do
      conn = put conn, sport_complex_path(conn, :update, sport_complex), sport_complex: @update_attrs
      assert redirected_to(conn) == sport_complex_path(conn, :show, sport_complex)

      conn = get conn, sport_complex_path(conn, :show, sport_complex)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, sport_complex: sport_complex} do
      conn = put conn, sport_complex_path(conn, :update, sport_complex), sport_complex: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Sport complex"
    end
  end

  describe "delete sport_complex" do
    setup [:create_sport_complex]

    test "deletes chosen sport_complex", %{conn: conn, sport_complex: sport_complex} do
      conn = delete conn, sport_complex_path(conn, :delete, sport_complex)
      assert redirected_to(conn) == sport_complex_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, sport_complex_path(conn, :show, sport_complex)
      end
    end
  end

  defp create_sport_complex(_) do
    sport_complex = fixture(:sport_complex)
    {:ok, sport_complex: sport_complex}
  end
end
