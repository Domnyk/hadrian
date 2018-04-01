defmodule Hadrian.Owners.SportObject do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:sport_object_id, :id, autogenerate: true}

  schema "sport_objects" do
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string

    belongs_to :sport_complex, Hadrian.Owners.SportComplex, references: :sport_complex_id
    has_many :sport_arenas, Hadrian.Owners.SportArena, foreign_key: :sport_object_id
  end

  @doc false
  def changeset(sport_object, attrs) do
    sport_object
    |> cast(attrs, [:name, :longitude, :latitude])
    |> validate_required([:name, :longitude, :latitude])
  end
end
