defmodule Types.TimeInterval do
  # This module implements Ecto.Type behaviour allowing to easily convert from and to %Postgrex.Interval{} struct

  @behaviour Ecto.Type

  Code.ensure_loaded(Postgrex)

  def type do
    Postgrex.Interval
  end

  @doc """
  Casts from map with string keys and int values
  ## Examples
  
      iex> TimeInterval.cast(%{months: 0, days: 7, secs: 0})
      {:ok, %Postgrex.Interval{days: 7, months: 0, secs: 0}}
  """
  def cast(%{"months" => months, "days" => days, "secs" => secs}) when is_integer(months) and is_integer(days) 
                                                                  and is_integer(secs) do
    {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  end
  
  def cast(_) do
    :error
  end

  @doc """
  Called when loading data from database. Returns tuple with %Postgrex.Interval struct.
  ## Examples
      iex> TimeIntervla.load(%{months: 0, days: 7, secs: 0})
      {:ok, %Postgrex.Interval{days: 7, months: 0, secs: 0}}
  """
  def load(%{months: months, days: days, secs: secs}) do
    {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  end

  @doc """
  Called when saving data into database. Returns tuple with %Postgrex.Interval struct.
  ## Examples
    
    iex> TimeInteval.dump(%{months: 0, days: 7, secs: 0})
    {:ok, %Postgrex.Interval{days: 7, months: 0, secs: 0}}
    
  """
  def dump(%{months: months, days: days, secs: secs}) when is_integer(months) and is_integer(days) 
                                                      and is_integer(secs) do
    {:ok, %Postgrex.Interval{months: months, days: days, secs: secs}}
  end

  def dump(_) do
    :error
  end
end