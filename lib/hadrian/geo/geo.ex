defmodule Hadrian.Geo do
  @earth_radius_km 6371
  @d2r :math.pi / 180

  def deg_to_rad(deg), do: deg * @d2r

  def distance(p1, p2, :km), do: haversine(p1, p2) * @earth_radius_km
  def distance(p1, p2, :m), do: distance(p1, p2, :km) * 1000

  @doc """
  Calculate the [Haversine](https://en.wikipedia.org/wiki/Haversine_formula)
  distance between two coordinates. Result is in radians. This result can be
  multiplied by the sphere's radius in any unit to get the distance in that unit.
  For example, multiple the result of this function by the Earth's radius in
  kilometres and you get the distance between the two given points in kilometres.
  """
  def haversine({lat1, lon1}, {lat2, lon2}) do
    dlat = deg_to_rad(lat2 - lat1)
    dlon = deg_to_rad(lon2 - lon1)

    radlat1 = deg_to_rad(lat1)
    radlat2 = deg_to_rad(lat2)

    a = :math.pow(:math.sin(dlat / 2), 2) +
        :math.pow(:math.sin(dlon / 2), 2) *
        :math.cos(radlat1) * :math.cos(radlat2)

    2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
  end
end