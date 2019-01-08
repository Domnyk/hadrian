defmodule Hadrian.Owners.SportComplex do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sport_complexes" do
    field :name, :string

    has_many :sport_objects, Hadrian.Owners.SportObject, foreign_key: :sport_complex_id
    belongs_to :complexes_owner, Hadrian.Accounts.ComplexesOwner, references: :id
  end

  @doc false
  def changeset(sport_complex, attrs) do
    sport_complex
    |> cast(attrs, [:name, :complexes_owner_id])
    |> unique_constraint(:name, name: "sport_complex_name_idx")
    |> validate_required([:name, :complexes_owner_id])
  end
end
