defmodule Hadrian.SportsVenueTest do
  use Hadrian.DataCase

  alias Hadrian.SportsVenue

  describe "sports_disciplines" do
    alias Hadrian.SportsVenue.SportsDiscipline

    @valid_attrs %{min_num_of_people: 42, name: "some name", required_equipment: "some required_equipment"}
    @update_attrs %{min_num_of_people: 43, name: "some updated name", required_equipment: "some updated required_equipment"}
    @invalid_attrs %{min_num_of_people: nil, name: nil, required_equipment: nil}

    def sports_discipline_fixture(attrs \\ %{}) do
      {:ok, sports_discipline} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SportsVenue.create_sports_discipline()

      sports_discipline
    end

    test "list_sports_disciplines/0 returns all sports_disciplines" do
      sports_discipline = sports_discipline_fixture()
      assert SportsVenue.list_sports_disciplines() == [sports_discipline]
    end

    test "get_sports_discipline!/1 returns the sports_discipline with given id" do
      sports_discipline = sports_discipline_fixture()
      assert SportsVenue.get_sports_discipline!(sports_discipline.id) == sports_discipline
    end

    test "create_sports_discipline/1 with valid data creates a sports_discipline" do
      assert {:ok, %SportsDiscipline{} = sports_discipline} = SportsVenue.create_sports_discipline(@valid_attrs)
      assert sports_discipline.min_num_of_people == 42
      assert sports_discipline.name == "some name"
      assert sports_discipline.required_equipment == "some required_equipment"
    end

    test "create_sports_discipline/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SportsVenue.create_sports_discipline(@invalid_attrs)
    end

    test "update_sports_discipline/2 with valid data updates the sports_discipline" do
      sports_discipline = sports_discipline_fixture()
      assert {:ok, sports_discipline} = SportsVenue.update_sports_discipline(sports_discipline, @update_attrs)
      assert %SportsDiscipline{} = sports_discipline
      assert sports_discipline.min_num_of_people == 43
      assert sports_discipline.name == "some updated name"
      assert sports_discipline.required_equipment == "some updated required_equipment"
    end

    test "update_sports_discipline/2 with invalid data returns error changeset" do
      sports_discipline = sports_discipline_fixture()
      assert {:error, %Ecto.Changeset{}} = SportsVenue.update_sports_discipline(sports_discipline, @invalid_attrs)
      assert sports_discipline == SportsVenue.get_sports_discipline!(sports_discipline.id)
    end

    test "delete_sports_discipline/1 deletes the sports_discipline" do
      sports_discipline = sports_discipline_fixture()
      assert {:ok, %SportsDiscipline{}} = SportsVenue.delete_sports_discipline(sports_discipline)
      assert_raise Ecto.NoResultsError, fn -> SportsVenue.get_sports_discipline!(sports_discipline.id) end
    end

    test "change_sports_discipline/1 returns a sports_discipline changeset" do
      sports_discipline = sports_discipline_fixture()
      assert %Ecto.Changeset{} = SportsVenue.change_sports_discipline(sports_discipline)
    end
  end
end
