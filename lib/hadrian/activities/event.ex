defmodule Hadrian.Activities.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hadrian.Accounts.User
  alias Hadrian.Activities.Participator
  alias Hadrian.Repo

  schema "events" do
    field :name,                      :string
    field :max_num_of_participants,   :integer
    field :min_num_of_participants,   :integer
    field :event_day,                 :date
    field :end_of_joining_phase,      :date
    field :end_of_paying_phase,       :date
    field :start_time,                :time
    field :end_time,                  :time

    belongs_to :sport_arena, Hadrian.Owners.SportArena
    many_to_many :users, Hadrian.Accounts.User, join_through: Participator, on_replace: :delete
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> Repo.preload(:users)
    |> cast(attrs, [:name, :min_num_of_participants, :max_num_of_participants, :event_day, :end_of_joining_phase,
                    :end_of_paying_phase, :start_time, :end_time, :sport_arena_id])
    |> validate_required([:name, :min_num_of_participants, :max_num_of_participants, :event_day, :end_of_joining_phase,
                          :end_of_paying_phase, :start_time, :end_time, :sport_arena_id])
  end
end
