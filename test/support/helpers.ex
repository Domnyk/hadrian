defmodule Hadrian.Helpers do

  @doc """
    Reverse of Repo.preload/3

    Replaces 'field: %struct{}' with 'field: #Ecto.Association.NotLoaded<association :struct is not loaded>'
  """
  def unpreload(struct, field, cardinality \\ :one) do
    %{struct |
      field => %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: struct.__struct__,
        __cardinality__: cardinality
      }
    }
  end

end
