defmodule HadrianWeb.BookingMarginHelperTest do
  use HadrianWeb.ConnCase
  
  alias HadrianWeb.BookingMarginHelper

  require Logger

  describe "edit_map_to_fit_to_model_def/1" do
    test "it creates key with name 'booking margin'" do
      unfitted_map = %{"booking_margin_months" => "3", "booking_margin_days" => "2", "name" => "Football pitch",
                      "longitude" => "21.2", "latitude" => "3.2", "sport_complex_id" => "1"}

      fitted_map = BookingMarginHelper.edit_map_to_fit_to_model_def(unfitted_map)

      assert Map.has_key?(fitted_map, "booking_margin")
    end

    test "it puts proper value under key 'booking margin'" do
      num_of_months = "3"
      num_of_days = "2"
      unfitted_map = %{"booking_margin_months" => num_of_months, "booking_margin_days" => num_of_days, 
                      "name" => "Football pitch", "longitude" => "21.2", "latitude" => "3.2", 
                      "sport_complex_id" => "1"}
      {:ok, expected_value} = EctoInterval.cast(%{"months" => num_of_months, "days" => num_of_days, "secs" => "0"})

      fitted_map = BookingMarginHelper.edit_map_to_fit_to_model_def(unfitted_map)
      actual_value = Map.get(fitted_map, "booking_margin")

      assert Map.equal?(actual_value, expected_value)
    end
  end
end