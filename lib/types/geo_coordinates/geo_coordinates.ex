defmodule Types.GeoCoordinates do
  @enforce_keys [:latitude, :longitude]
  
  defstruct latitude: nil, 
            longitude: nil

  @type t() :: %__MODULE__ {
    latitude: float(),
    longitude: float()
  }
end