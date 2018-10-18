defmodule Hadrian.Owners.SportArena do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sport_arenas" do
    field :name, :string

		belongs_to :sport_object, Hadrian.Owners.SportObject, references: :id
		has_many :daily_schedules, Hadrian.Owners.DailySchedule, foreign_key: :sport_arena_id 
	end

  @doc false
  def changeset(sport_arena, attrs) do
    sport_arena
    |> cast(attrs, [:name, :sport_object_id])
    |> foreign_key_constraint(:sport_object_id)
    |> validate_required([:name, :sport_object_id])
  end
end
