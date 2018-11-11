defmodule Hadrian.Repo.Migrations.AddDailySchedules do
  use Ecto.Migration

  def up do
    create table("daily_schedules") do
      add :schedule_day,    :date
      add :is_day_off,      :boolean
      add :sport_arena_id,  references("sport_arenas")
    end

    create index("daily_schedules", [:schedule_day], name: "schedule_day_idx")
    create index("daily_schedules", [:sport_arena_id], name: "sport_arena_id_idx")
  end

  def down do
    drop index("daily_schedules", [:schedule_day], name: "schedule_day_idx")
    drop index("daily_schedules", [:sport_arena_id], name: "sport_arena_id_idx")

    drop table("daily_schedules")
  end
end
