defmodule Hadrian.ActivitiesTest do
  use Hadrian.DataCase

  alias Hadrian.Activities

  describe "events" do
    alias Hadrian.Activities.Event

    
    @update_attrs %{max_num_of_participants: 50, min_num_of_participants: 43, 
                    duration_of_joining_phase: %{"months" => 0, "days" => 5, "secs" => 0},
                    duration_of_paying_phase: %{"months" => 0, "days" => 5, "secs" => 0}}
    @invalid_attrs %{max_num_of_participants: nil, min_num_of_participants: nil, duration_of_joining_phase: nil,
                    duration_of_paying_phase: nil, time_block_id: nil}

    test "list_events/0 returns all events" do
      events_list = insert_list(3, :event)

      assert Activities.list_events() == events_list
    end

    test "get_event!/1 returns the event with given id" do
      event = insert(:event)

      assert Activities.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates an event" do
      daily_schedule = insert(:daily_schedule)
      valid_attrs = %{max_num_of_participants: 100, min_num_of_participants: 42,
                    start_time: ~T[13:00:00.000000], end_time: ~T[15:00:00.000000],
                    duration_of_joining_phase: %{"months" => 0, "days" => 7, "secs" => 0},
                    duration_of_paying_phase: %{"months" => 0, "days" => 7, "secs" => 0}, daily_schedule_id: daily_schedule.id}
      
      assert {:ok, %Event{} = event} = Activities.create_event(valid_attrs)
      assert event.duration_of_joining_phase == %Postgrex.Interval{months: 0, days: 7, secs: 0}
      assert event.duration_of_paying_phase == %Postgrex.Interval{months: 0, days: 7, secs: 0}
      assert event.max_num_of_participants == valid_attrs.max_num_of_participants
      assert event.min_num_of_participants == valid_attrs.min_num_of_participants
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      daily_schedule = insert(:daily_schedule)
      event = insert(:event, daily_schedule_id: daily_schedule.id)

      assert {:ok, updated_event} = Activities.update_event(event, @update_attrs)
      assert %Event{} = updated_event
      assert updated_event.duration_of_joining_phase == %Postgrex.Interval{months: 0, days: 5, secs: 0}
      assert updated_event.duration_of_paying_phase == %Postgrex.Interval{months: 0, days: 5, secs: 0}
      assert updated_event.max_num_of_participants == @update_attrs.max_num_of_participants
      assert updated_event.min_num_of_participants == @update_attrs.min_num_of_participants
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = insert(:event)

      assert {:error, %Ecto.Changeset{}} = Activities.update_event(event, @invalid_attrs)
      assert event == Activities.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = insert(:event)

      assert {:ok, %Event{}} = Activities.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = insert(:event)

      assert %Ecto.Changeset{} = Activities.change_event(event)
    end
  end
end
