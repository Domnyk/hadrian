defmodule Hadrian.Repo.Migrations.AddExternalEvents do
  use Ecto.Migration

  def up do
    create table(:external_events) do
      add :event_day,                 :date, null: false
      add :start_time,                :time, null: false
      add :end_time,                  :time, null: false
      add :sport_arena_id,            references("sport_arenas"), null: false
    end

    create constraint(:external_events, :end_time_later_than_start_time, check: "end_time > start_time")
  end

  def down do
    drop constraint(:external_events, :end_time_later_than_start_time)
    drop table(:external_events)
  end
end
