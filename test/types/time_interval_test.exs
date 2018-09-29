defmodule TimeIntervalTest do
  use ExUnit.Case, async: true
  
  alias Types.TimeInterval
  
  describe "type" do
    test "returns Postgrex.Interval" do
      assert TimeInterval.type == Postgrex.Interval
    end
  end

  describe "cast" do
    test "returns tuple with {:ok, %Postgrex.Intervla} when casting succeeds" do
      time_interval_params = %{"months" => 1, "days" => 5, "secs" => 120}

      assert {:ok, %Postgrex.Interval{} = time_interval} = TimeInterval.cast(time_interval_params)
      assert time_interval.months == time_interval_params["months"]
      assert time_interval.days == time_interval_params["days"]
      assert time_interval.secs == time_interval_params["secs"]
    end

    test "returns :error when input argument can't be cast to this type" do
      time_interval_params = %{"this" => "is", "wrong" => "."}

      assert :error = TimeInterval.cast(time_interval_params)
    end
  end

  describe "load" do
    test "returns {:ok, %Postgrex.Inteval{}}" do
      time_interval_from_db = %{months: 1, days: 5, secs: 120}

      assert {:ok, %Postgrex.Interval{} = time_interval} = TimeInterval.load(time_interval_from_db)
      assert time_interval_from_db.months == time_interval.months
      assert time_interval_from_db.days == time_interval.days
      assert time_interval_from_db.secs == time_interval.secs
    end
  end

  describe "dump" do
    test "returns {:ok, %Postgrex.Interaval{}} when input map has correct format" do
      time_interval_params = %{months: 1, days: 5, secs: 120}
      
      assert {:ok, %Postgrex.Interval{} = time_interval} = TimeInterval.dump(time_interval_params)
      assert time_interval.months == time_interval_params.months
      assert time_interval.days == time_interval_params.days
      assert time_interval.secs == time_interval_params.secs
    end

    test "returns :error when input argument can't be dump into Ecto native type" do
      time_interval_params = %{"this" => "is", "wrong" => "."}

      assert :error = TimeInterval.dump(time_interval_params)
    end
  end
end