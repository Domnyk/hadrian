defmodule Hadrian.Time do
  @seconds_in_hour 3600

  def diff_in_hours(%Time{} = t1, %Time{} = t2) do
    if (Time.compare(t1, t2) == :lt) do
      Hadrian.Time.diff_in_hours(t2, t1)
    else
      diff_in_seconds = Time.diff(t1, t2)
      diff_in_seconds / @seconds_in_hour
    end
  end
end
