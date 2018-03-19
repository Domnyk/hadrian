defmodule Hadrian.ActivitiesTest do
  use Hadrian.DataCase

  alias Hadrian.Activities

  describe "events" do
    alias Hadrian.Activities.Event

    @valid_attrs %{end_of_joining_phase: "2010-04-17 14:00:00.000000Z", max_num_of_participants: 42, min_num_of_participants: 42}
    @update_attrs %{end_of_joining_phase: "2011-05-18 15:01:01.000000Z", max_num_of_participants: 43, min_num_of_participants: 43}
    @invalid_attrs %{end_of_joining_phase: nil, max_num_of_participants: nil, min_num_of_participants: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Activities.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Activities.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Activities.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Activities.create_event(@valid_attrs)
      assert event.end_of_joining_phase == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert event.max_num_of_participants == 42
      assert event.min_num_of_participants == 42
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Activities.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.end_of_joining_phase == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert event.max_num_of_participants == 43
      assert event.min_num_of_participants == 43
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_event(event, @invalid_attrs)
      assert event == Activities.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Activities.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Activities.change_event(event)
    end
  end
end
