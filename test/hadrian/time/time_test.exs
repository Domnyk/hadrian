defmodule Hadrian.TimeTest do
  use Hadrian.DataCase

  describe "diff_in_hours/2" do
    test "returns time difference in hours" do
      time_1 = ~T[12:00:00.000000]
      time_2 = ~T[13:30:00.000000]

      assert Hadrian.Time.diff_in_hours(time_2, time_1) == 1.5
    end

    test "calculates difference regardless of which function's argumnent is later in time" do
      time_1 = ~T[12:00:00.000000]
      time_2 = ~T[13:30:00.000000]

      assert Hadrian.Time.diff_in_hours(time_2, time_1) == 1.5
      assert Hadrian.Time.diff_in_hours(time_1, time_2) == 1.5
    end
  end

end
