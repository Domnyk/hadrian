defmodule Hadrian.DataFactory do
  use ExMachina.Ecto, repo: Hadrian.Repo

  def booking_margin_factory do
    num_of_months = Enum.random(1..100)
     
    %{"months" => num_of_months, "days" => 2, "secs" => 10}
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
    alias Types.TimeInterval
    
    name_val = &"Sport object number #{&1}"
    
    %SportObject{
      name: sequence(:name, name_val),
      geo_coordinates: sequence(:geo_coordinates, gen_geo_coordinates_val),
      booking_margin: %{"months" => 1, "days" => 2, "secs" => 3}
    }
  end

  # TODO: Generate sport object params map. Maybe this could be done via sport_object_factory/0 ?
  def sport_object_params_factory do
    %{
      "data" => %{
        "sport_object" => %{
          "name" => "Some funny sport object name",
          "geo_coordinates" => %{
            "latitude" => sequence(:latitude, gen_latitude_val),
            "longitude" => sequence(:longitude, gen_longitude_val)
          },
          "booking_margin" => %{
            "months" => "1",
            "days" => "1",
            "secs" => "1"
          },
          "sport_complex_id" => 1
        }
      }
    }
  end

  defp gen_geo_coordinates_val do
    alias Types.GeoCoordinates

    geo_coordinates = %GeoCoordinates{
      latitude: sequence(:latitude, gen_latitude_val),
      longitude: sequence(:longitude, gen_longitude_val)
    }

    fn _ -> geo_coordinates end
  end

  defp gen_latitude_val do
    whole_val = "56"
    fractional_val = Enum.random(100000..999999) |> Integer.to_string
    latitude_val = String.to_float(whole_val <> "." <> fractional_val)

    fn _ -> latitude_val end
  end

  defp gen_longitude_val do
    whole_val = "145"
    fractional_val = Enum.random(100000..999999) |> Integer.to_string
    longitude_val = String.to_float(whole_val <> "." <> fractional_val)

    fn _ -> longitude_val end
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

    %User{
      password: "Very strong password",
      email: sequence(:email, &"test#{&1}@domain.com")
    }
  end

  def user_attrs_factory do
    %{
      "password" => "Very strong password",
      "email" => sequence(:email, &"test#{&1}@domain.com")
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