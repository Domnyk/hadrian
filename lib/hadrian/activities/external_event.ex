defmodule Hadrian.Activities.ExternalEvent do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "external_events" do
    field :event_day,                 :date
    field :start_time,                :time
    field :end_time,                  :time

    belongs_to :sport_arena, Hadrian.Owners.SportArena
  end

  def changeset(external_event, attrs) do
    external_event
    |> cast(attrs, [:event_day, :start_time, :end_time, :sport_arena_id])
    |> validate_required([:event_day, :start_time, :end_time, :sport_arena_id])

  end
end
