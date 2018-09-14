defmodule Types.GeoCoordinates do
  @enforce_keys [:latitude, :longitude]
  
  defstruct latitude: nil, 
            longitude: nil

  @type t() :: %__MODULE__ {
    latitude: Decimal.t(),
    longitude: Decimal.t()
  }
end