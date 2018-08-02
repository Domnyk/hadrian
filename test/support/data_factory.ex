defmodule Hadrian.DataFactory do
  use ExMachina.Ecto, repo: Hadrian.Repo

  def booking_margin_factory do
    num_of_months = Enum.random(1..100)
    {:ok, booking_margin} = EctoInterval.cast(%{months: num_of_months, days: 2, secs: 10})

    booking_margin
  end

  def sport_complex_factory do
    alias Hadrian.Owners.SportComplex

    %SportComplex{
      name: sequence(:name, &"OSIR #{&1}")
    }
  end

  def sport_object_factory do
    alias Decimal
    alias Hadrian.Owners.SportObject
    
    name_val = &"Boisko nr. #{&1}"
    latitude_val = &"56.#{&1 + 1}2300#{&1}"
    longitude_val = &"145.#{&1 + 2}6700#{&1}"
    {:ok, booking_margin_val} = EctoInterval.cast(%{"months" => "1", "days" => "2", "secs" => "3"})

    %SportObject{
      name: sequence(:name, name_val),
      latitude: sequence(:latitude, latitude_val),
      longitude: sequence(:longitude, longitude_val),
      booking_margin: booking_margin_val
    }
  end

  def sport_arena_factory do
    alias Hadrian.Owners.SportArena

    %SportArena{
      name: "Sport Arena of city Fake",
      type: "Fake soccer field"
    }
  end

  def daily_schedule_factory do
    alias Hadrian.Owners.DailySchedule

    %DailySchedule{
      schedule_day: ~D[2018-07-14]
    }
  end

  def time_block_factory do
    alias Hadrian.Owners.TimeBlock

    %TimeBlock{
      start_hour: ~T[14:00:00.000000],
      end_hour: ~T[15:00:00.000000]
    }
  end

  def user_factory do
    alias Hadrian.Accounts.User

    # AKA Captain America :D
    %User{
      first_name: "Steve",
      last_name: "Rogers"
    }
  end

  def event_factory do
    alias Hadrian.Activities.Event

    %Event{
      min_num_of_participants: 2,
      max_num_of_participants: 10,
      duration_of_joining_phase: %{months: 0, days: 5, secs: 0},
      duration_of_paying_phase: %{months: 1, days: 7, secs: 0}
    }
  end
end