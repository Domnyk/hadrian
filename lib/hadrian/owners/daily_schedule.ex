defmodule Hadrian.Owners.DailySchedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_schedules" do
    field :schedule_day, :date
    field :is_day_off,   :boolean

    belongs_to :sport_arena, Hadrian.Owners.SportArena, references: :id
  end

  @doc false
  def changeset(daily_schedule, attrs) do
    daily_schedule
    |> cast(attrs, [:schedule_day, :is_day_off, :sport_arena_id])
    |> validate_required([:schedule_day, :is_day_off, :sport_arena_id])
  end
end
