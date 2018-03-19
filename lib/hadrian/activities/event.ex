defmodule Hadrian.Activities.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:event_id, :id, autogenerate: true}

  schema "events" do
    field :max_num_of_participants, :integer
    field :min_num_of_participants, :integer
    field :end_of_joining_phase, :utc_datetime

    belongs_to :time_block, Hadrian.Owners.TimeBlock, references: :time_block_id
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:min_num_of_participants, :max_num_of_participants, :end_of_joining_phase])
    |> validate_required([:min_num_of_participants, :max_num_of_participants, :end_of_joining_phase])
  end
end
