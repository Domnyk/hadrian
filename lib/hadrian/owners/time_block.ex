defmodule Hadrian.Owners.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "time_blocks" do
    field :end_hour, :time
    field :start_hour, :time

    belongs_to :daily_schedule, Hadrian.Owners.DailySchedule, references: :daily_schedule_id
    has_one :event, Hadrian.Activities.Event, foreign_key: :time_block_id
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
    |> cast(attrs, [:start_hour, :end_hour, :daily_schedule_id])
    |> validate_required([:start_hour, :end_hour, :daily_schedule_id])
  end
end
