defmodule Hadrian.DataFactory do
  use ExMachina.Ecto, repo: Hadrian.Repo

  def booking_margin_factory do
    num_of_months = Enum.random(1..100)
     
    %{"months" => num_of_months, "days" => 2, "secs" => 10}
  end

  def complexes_owner_factory do
    alias Hadrian.Accounts.ComplexesOwner

    %ComplexesOwner{
      password: "Very secret password",
      email: sequence(:email, &"test#{&1}@domain.com")
    }
  end

  def complexes_owner_attrs_factory do
    %{
      "email" => sequence(:email, &"test#{&1}@domain.com"),
      "password" => "Very secret password"
    }
  end

  def sport_complex_factory do
    alias Hadrian.Owners.SportComplex

    %SportComplex{
      name: sequence(:name, &"OSIR #{&1}")
    }
  end

  def sport_complex_attrs_factory do
    %{
      "data" => %{
        "sport_complex" => %{
          "name" => sequence(:name, &"OSIR #{&1}")
        }
      }   
    }
  end

  def sport_object_factory do
    alias Decimal
    alias Hadrian.Owners.SportObject
    
    name_val = &"Sport object number #{&1}"
    
    %SportObject{
      name: sequence(:name, name_val),
      geo_coordinates: sequence(:geo_coordinates, gen_geo_coordinates_val()),
      address: sequence(:address, gen_address_val()),
      booking_margin: %{"months" => 0, "days" => 2, "secs" => 3}
    }
  end

  def sport_object_params_factory do
    %{
      "data" => %{
        "sport_object" => %{
          "name" => "Some funny sport object name",
          "geo_coordinates" => %{
            "latitude" => sequence(:latitude, gen_latitude_val()),
            "longitude" => sequence(:longitude, gen_longitude_val())
          },
          "booking_margin" => %{
            "months" => 1,
            "days" => 1,
            "secs" => 1
          },
          "address" => %{
            "street" => sequence(:street, &"Ulica #{&1}"),
            "building_number" => sequence(:building_number, &"#{&1}"),
            "postal_code" => sequence(:postal_code, gen_postal_code()),
            "city" => sequence(:city, &"Miasto #{&1}")
          },
          "sport_complex_id" => 1
        }
      }
    }
  end

  defp gen_address_val do
    alias Types.Address

    address = %Address{
      street: sequence(:street, &"Ulica #{&1}"),
      building_number: sequence(:building_number, &"#{&1}"),
      postal_code: sequence(:postal_code, gen_postal_code()),
      city: sequence(:city, &"Miasto #{&1}")
    }

    fn _ -> address end
  end

  defp gen_postal_code do
    first_part = Enum.random(10..99) |> Integer.to_string
    second_part = Enum.random(100..999) |> Integer.to_string
    postal_code = first_part <> "-" <> second_part

    fn _ -> postal_code end
  end

  defp gen_geo_coordinates_val do
    alias Types.GeoCoordinates

    geo_coordinates = %GeoCoordinates{
      latitude: sequence(:latitude, gen_latitude_val()),
      longitude: sequence(:longitude, gen_longitude_val())
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
      name: "Sport Arena of city Fake"
    }
  end

  def sport_arena_params_factory do
    %{
      "data" => %{
        "sport_arena" => %{
          "name" => "Sport arena of city Fake",
          "sport_disciplines" => [
            %{"id" => 1, "name" => "Football"},
            %{"id" => 2, "name" => "Basketball"}
          ]
        }
      }
    }
  end

  def sport_discipline_factory do
    alias Hadrian.Owners.SportDiscipline

    %SportDiscipline{
      name: "Football"
    }
  end

  def user_factory do
    alias Hadrian.Accounts.User

    %User{
      display_name: sequence(:display_name, &"Display name #{&1}"),
      email: sequence(:email, &"test#{&1}@domain.com")
    }
  end

  def user_attrs_factory do
    %{
      "display_name" => sequence(:display_name, &"Display name #{&1}"),
      "email" => sequence(:email, &"test#{&1}@domain.com")
    }
  end

  def event_factory do
    alias Hadrian.Activities.Event

    today = DateTime.to_date(DateTime.utc_now())
    today_plus_week = Date.add(today, 7)
    today_plus_two_weeks = Date.add(today, 14)
    start_time = ~T[13:00:00.000000]
    end_time = Time.add(start_time, 7200, :second)

    %Event{
      name: sequence(:name, &"Event number #{&1}"),
      min_num_of_participants: 2,
      max_num_of_participants: 10,
      event_day: today_plus_two_weeks,
      end_of_joining_phase: today,
      end_of_paying_phase: today_plus_week,
      start_time: start_time,
      end_time: end_time
    }
  end
end