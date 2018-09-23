defmodule Hadrian.Owners.SportComplex do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sport_complexes" do
    field :name, :string

    has_many :sport_objects, Hadrian.Owners.SportObject, foreign_key: :sport_complex_id
  end

  @doc false
  def changeset(sport_complex, attrs) do
    sport_complex
    |> cast(attrs, [:name])
    |> unique_constraint(:name, name: "sport_complex_name_idx")
    |> no_assoc_constraint(:sport_objects)
    |> validate_required([:name])
  end
end
