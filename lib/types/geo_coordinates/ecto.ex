defmodule Types.GeoCoordinates.Ecto do
  @behaviour Ecto.Type

  alias Types.GeoCoordinates

  def type do
    :map
  end

  def cast(%{latitude: latitude, longitude: longitude} = geo_coordinates) when is_map(geo_coordinates) do
    struct = %GeoCoordinates{latitude: latitude, longitude: longitude}
    
    {:ok, struct}
  end

  def cast(_) do 
    :error
  end

  def load(data) when is_map(data) do
    data = 
      for {key, val} <- data do
        {String.to_existing_atom(key), val}
      end

    {:ok, struct!(GeoCoordinates, data)}
  end

  def dump(%GeoCoordinates{} = geo_coordinates) do
    {:ok, Map.from_struct(geo_coordinates)}
  end

  def dump(_) do
    :error
  end
end