defmodule Hadrian.Owners.SportObject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Types.TimeInterval

  schema "sport_objects" do
    field :geo_coordinates, Types.GeoCoordinates.Ecto
    field :name, :string
    field :booking_margin, TimeInterval, default: %{months: 0, days: 0, secs: 0} 

    belongs_to :sport_complex, Hadrian.Owners.SportComplex, references: :id
    has_many :sport_arenas, Hadrian.Owners.SportArena, foreign_key: :sport_object_id
  end

  @doc false
  def changeset(sport_object, attrs) do
    sport_object
    |> cast(attrs, [:name, :geo_coordinates, :sport_complex_id, :booking_margin])
    |> foreign_key_constraint(:sport_complex_id)
    |> validate_required([:name, :geo_coordinates, :sport_complex_id, :booking_margin])
  end
end