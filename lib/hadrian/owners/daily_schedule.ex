defmodule Hadrian.Owners.DailySchedule do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:daily_schedule_id, :id, autogenerate: true}

  schema "daily_schedules" do
    field :schedule_day, :date

    belongs_to :sport_object, Hadrian.Owners.SportObject, references: :sport_object_id
    has_many :time_blocks, Hadrian.Owners.TimeBlock, foreign_key: :daily_schedule_id
  end

  @doc false
  def changeset(daily_schedule, attrs) do
    daily_schedule
    |> cast(attrs, [:schedule_day])
    |> validate_required([:schedule_day])
  end
end
