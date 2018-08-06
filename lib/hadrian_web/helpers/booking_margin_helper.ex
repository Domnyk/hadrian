defmodule HadrianWeb.BookingMarginHelper do
  def edit_map_to_fit_to_model_def(sport_object_params) do
    booking_margin_months = Map.get(sport_object_params, "booking_margin_months")
    booking_margin_days = Map.get(sport_object_params, "booking_margin_days")

    {:ok, booking_margin} = EctoInterval.cast(%{"months" => booking_margin_months, "days" => booking_margin_days, "secs" => "0"})

    sport_object_params = sport_object_params
    |> Map.put("booking_margin", booking_margin)
    |> Map.delete("booking_margin_months")
    |> Map.delete("booking_margin_days")
  end

  def get_booking_value(booking_margin, period) do
    if booking_margin == nil do
      "0"
    else 
      Map.get(booking_margin, period)
    end
  end 
end