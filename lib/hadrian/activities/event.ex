defmodule Hadrian.Activities.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Types.TimeInterval

  schema "events" do
    field :max_num_of_participants,   :integer
    field :min_num_of_participants,   :integer
    field :duration_of_joining_phase, TimeInterval, default: %{months: 0, days: 0, secs: 0}
    field :duration_of_paying_phase,  TimeInterval, default: %{months: 0, days: 0, secs: 0}
    field :start_time,                :time
    field :end_time,                  :time
    timestamps()

    belongs_to :daily_schedule, Hadrian.Owners.DailySchedule, references: :id
    many_to_many :users, Hadrian.Accounts.User, join_through: "users_in_events"
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:min_num_of_participants, :max_num_of_participants, :duration_of_joining_phase,
                    :duration_of_paying_phase, :start_time, :end_time, :daily_schedule_id])
    |> validate_required([:min_num_of_participants, :max_num_of_participants, :duration_of_joining_phase,
                          :duration_of_paying_phase, :start_time, :end_time, :daily_schedule_id])
  end
end
