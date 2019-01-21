defmodule Hadrian.Geo do
  @earth_rad_in_km 6371
  @deg_to_rad_factor :math.pi / 180

  def deg_to_rad(deg), do: deg * @deg_to_rad_factor

  def distance(p1, p2, :km), do: haversine(p1, p2) * @earth_rad_in_km
  def distance(p1, p2, :m), do: distance(p1, p2, :km) * 1000

  @doc """
  Calculate the Haversine distance between two coordinates. Result in radians.
  """
  def haversine({lat1, lon1}, {lat2, lon2}) do
    d_longitude = deg_to_rad(lon2 - lon1)
    d_latitude = deg_to_rad(lat2 - lat1)

    radlat1 = deg_to_rad(lat1)
    radlat2 = deg_to_rad(lat2)

    a = :math.pow(:math.sin(d_latitude / 2), 2) +
        :math.pow(:math.sin(d_longitude / 2), 2) *
        :math.cos(radlat1) * :math.cos(radlat2)

    2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
  end
end