defmodule Hadrian.Owners.SportDiscipline do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hadrian.Owners.SportArena

  schema "sport_disciplines" do
    field :name, :string

    many_to_many :sport_arenas, SportArena, join_through: "sport_disciplines_in_sport_arenas"
  end

  @doc false
  def changeset(sport_discipline, attrs) do
    sport_discipline
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
