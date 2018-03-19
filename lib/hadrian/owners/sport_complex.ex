defmodule Hadrian.Owners.SportComplex do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:sport_complex_id, :id, autogenerate: true}

  schema "sport_complexes" do
    field :name, :string

    has_many :sport_objects, Hadrian.Owners.SportObject, foreign_key: :sport_complex_id
  end

  @doc false
  def changeset(sport_complex, attrs) do
    sport_complex
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
