defmodule Hadrian.Owners.SportObject do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sport_objects" do
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :booking_margin, EctoInterval, default: %{months: 0, days: 0, secs: 0} 

    belongs_to :sport_complex, Hadrian.Owners.SportComplex, references: :id
    has_many :sport_arenas, Hadrian.Owners.SportArena, foreign_key: :sport_object_id
  end

  @doc false
  def changeset(sport_object, attrs) do
    sport_object
    |> cast(attrs, [:name, :longitude, :latitude, :sport_complex_id, :booking_margin])
    |> validate_required([:name, :longitude, :latitude, :sport_complex_id, :booking_margin])
  end
end
