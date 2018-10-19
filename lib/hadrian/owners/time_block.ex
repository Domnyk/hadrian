defmodule Hadrian.Owners.TimeBlock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "time_blocks" do
    field :end_hour, :time
    field :start_hour, :time

    belongs_to :daily_schedule, Hadrian.Owners.DailySchedule, references: :id
    has_one :event, Hadrian.Activities.Event, foreign_key: :time_block_id
  end

  @doc false
  def changeset(time_block, attrs) do
    time_block
    |> cast(attrs, [:start_hour, :end_hour, :daily_schedule_id])
    |> validate_required([:start_hour, :end_hour, :daily_schedule_id])
    |> check_constraint(:start_hour,  [name: :end_hour_is_later_than_star_hour])
    |> check_constraint(:end_hour, [name: :end_hour_is_later_than_star_hour, 
                                    message: "End hour is earlier than start hour"])
  end
end
