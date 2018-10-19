defmodule Types.GeoCoordinates.Ecto do
  @behaviour Ecto.Type

  alias Types.GeoCoordinates

  def type do
    :map
  end

  def cast(%{latitude: latitude, longitude: longitude}) when is_number(latitude)
                                                                          and is_number(longitude) do
    struct = %GeoCoordinates{latitude: latitude, longitude: longitude}
    
    {:ok, struct}
  end

  def cast(%{"latitude" => latitude, "longitude" => longitude}) do
    cast(%{latitude: latitude, longitude: longitude}) 
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