defmodule HadrianWeb.SportsDisciplineControllerTest do
  use HadrianWeb.ConnCase

  alias Hadrian.SportsVenue

  @create_attrs %{min_num_of_people: 42, name: "some name", required_equipment: "some required_equipment"}
  @update_attrs %{min_num_of_people: 43, name: "some updated name", required_equipment: "some updated required_equipment"}
  @invalid_attrs %{min_num_of_people: nil, name: nil, required_equipment: nil}

  def fixture(:sports_discipline) do
    {:ok, sports_discipline} = SportsVenue.create_sports_discipline(@create_attrs)
    sports_discipline
  end

  describe "index" do
    test "lists all sports_disciplines", %{conn: conn} do
      conn = get conn, sports_discipline_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Sports disciplines"
    end
  end

  describe "new sports_discipline" do
    test "renders form", %{conn: conn} do
      conn = get conn, sports_discipline_path(conn, :new)
      assert html_response(conn, 200) =~ "New Sports discipline"
    end
  end

  describe "create sports_discipline" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, sports_discipline_path(conn, :create), sports_discipline: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == sports_discipline_path(conn, :show, id)

      conn = get conn, sports_discipline_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Sports discipline"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, sports_discipline_path(conn, :create), sports_discipline: @invalid_attrs
      assert html_response(conn, 200) =~ "New Sports discipline"
    end
  end

  describe "edit sports_discipline" do
    setup [:create_sports_discipline]

    test "renders form for editing chosen sports_discipline", %{conn: conn, sports_discipline: sports_discipline} do
      conn = get conn, sports_discipline_path(conn, :edit, sports_discipline)
      assert html_response(conn, 200) =~ "Edit Sports discipline"
    end
  end

  describe "update sports_discipline" do
    setup [:create_sports_discipline]

    test "redirects when data is valid", %{conn: conn, sports_discipline: sports_discipline} do
      conn = put conn, sports_discipline_path(conn, :update, sports_discipline), sports_discipline: @update_attrs
      assert redirected_to(conn) == sports_discipline_path(conn, :show, sports_discipline)

      conn = get conn, sports_discipline_path(conn, :show, sports_discipline)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, sports_discipline: sports_discipline} do
      conn = put conn, sports_discipline_path(conn, :update, sports_discipline), sports_discipline: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Sports discipline"
    end
  end

  describe "delete sports_discipline" do
    setup [:create_sports_discipline]

    test "deletes chosen sports_discipline", %{conn: conn, sports_discipline: sports_discipline} do
      conn = delete conn, sports_discipline_path(conn, :delete, sports_discipline)
      assert redirected_to(conn) == sports_discipline_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, sports_discipline_path(conn, :show, sports_discipline)
      end
    end
  end

  defp create_sports_discipline(_) do
    sports_discipline = fixture(:sports_discipline)
    {:ok, sports_discipline: sports_discipline}
  end
end
