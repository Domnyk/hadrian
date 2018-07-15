defmodule Hadrian.Owners.SportArena do
	use Ecto.Schema
	import Ecto.Changeset

	schema "sport_arenas" do
		field :name, :string
		field :type, :string

		belongs_to :sport_object, Hadrian.Owners.SportObject, references: :sport_object_id
		has_many :daily_schedules, Hadrian.Owners.DailySchedule, foreign_key: :sport_arena_id 
	end

	def changeset(sport_arena, attrs) do
    sport_arena
    |> cast(attrs, [:name, :type, :sport_object_id])
    |> validate_required([:name, :type, :sport_object_id])
  end
end