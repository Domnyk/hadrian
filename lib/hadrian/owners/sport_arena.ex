defmodule Hadrian.Owners.SportArena do
	use Ecto.Schema
	import Ecto.Changeset
	alias Hadrian.Owners.SportDiscipline
  alias Hadrian.Repo

  schema "sport_arenas" do
    field :name, :string

		belongs_to :sport_object, Hadrian.Owners.SportObject, references: :id
		has_many :daily_schedules, Hadrian.Owners.DailySchedule, foreign_key: :sport_arena_id 
		many_to_many :sport_disciplines, SportDiscipline, join_through: "sport_disciplines_in_sport_arenas"
	end

  @doc false
  def changeset(sport_arena, attrs) do
    sport_arena
    |> Repo.preload(:sport_disciplines)
    |> cast(attrs, [:name, :sport_object_id])
    |> foreign_key_constraint(:sport_object_id)
    |> validate_required([:name, :sport_object_id])
    |> put_assoc(:sport_disciplines, parse_sport_disciplines(attrs))
  end

  defp parse_sport_disciplines(attrs) do
    (attrs["sport_disciplines"] || [])
    |> Enum.map(& Repo.get(SportDiscipline, &1["id"]))
  end
end
