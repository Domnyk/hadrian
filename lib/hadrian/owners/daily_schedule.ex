defmodule Hadrian.Owners.DailySchedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_schedules" do
    field :schedule_day, :date

    belongs_to :sport_arena, Hadrian.Owners.SportArena, references: :id
    has_many :time_blocks, Hadrian.Owners.TimeBlock, foreign_key: :daily_schedule_id
  end

  @doc false
  def changeset(daily_schedule, attrs) do
    daily_schedule
    |> cast(attrs, [:schedule_day, :sport_arena_id])
    |> validate_required([:schedule_day, :sport_arena_id])
  end
end
