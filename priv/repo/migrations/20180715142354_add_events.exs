defmodule Hadrian.Repo.Migrations.AddEvents do
  use Ecto.Migration

  def up do
    create table(:events) do
      add :min_num_of_participants,   :int
      add :max_num_of_participants,   :int
      add :event_day,                 :date
      add :end_of_joining_phase,      :date
      add :end_of_paying_phase,       :date
      add :start_time,                :time
      add :end_time,                  :time
      add :sport_arena_id,            references("sport_arenas"), null: false

      timestamps()
    end

    create constraint(:events, :min_num_of_participants_bigger_than_0, check: "min_num_of_participants > 0")
    create constraint(:events, :max_num_of_participants_bigger_or_equal_than_min_num_of_participants,
                      check: "max_num_of_participants >= min_num_of_participants")
    create constraint(:events, :end_time_later_than_start_time, check: "end_time > start_time")
  end

  def down do
    drop constraint(:events, :end_time_later_than_start_time)
    drop constraint(:events, :max_num_of_participants_bigger_or_equal_than_min_num_of_participants)
    drop constraint(:events, :min_num_of_participants_bigger_than_0)
    drop table(:events)
  end
end
