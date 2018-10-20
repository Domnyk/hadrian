defmodule Types.Address do
  @moduledoc false

  defstruct street: nil,
            building_number: nil,
            postal_code: nil,
            city: nil

  @type t() :: %__MODULE__ {
    street: binary(),
    building_number: binary(),
    postal_code: binary(),
    city: binary()
  }

end
