defmodule Types.Address.Ecto do
  @behaviour Ecto.Type

  alias Types.Address

  def type do
    :map
  end

  def cast(%{street: street, building_number: building_number, postal_code: postal_code, city: city}) do
    struct = %Address{street: street, building_number: building_number, postal_code: postal_code, city: city}

    {:ok, struct}
  end

  def cast(%{"street" => street, "building_number" => building_number, "postal_code" => postal_code, "city" => city}) do
    cast(%{street: street, building_number: building_number, postal_code: postal_code, city: city})
  end

  def cast(_) do
    :error
  end

  def load(data) when is_map(data) do
    data =
      for {key, val} <- data do
        {String.to_existing_atom(key), val}
      end

    {:ok, struct!(Address, data)}
  end

  def dump(%Address{} = address) do
    {:ok, Map.from_struct(address)}
  end

  def dump(_) do
    :error
  end




end
