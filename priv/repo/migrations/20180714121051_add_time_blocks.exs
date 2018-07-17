defmodule Hadrian.Repo.Migrations.AddTimeBlocks do
  use Ecto.Migration

  def up do
    create table("time_blocks") do
      add :start_hour,        :time
      add :end_hour,          :time
      add :daily_schedule_id, references("daily_schedules")
    end

    create index("time_blocks", [:daily_schedule_id], name: "daily_schedule_id_idx")

    create constraint("time_blocks", :end_hour_is_later_than_star_hour, check: "end_hour > start_hour")
  end

  def down do
    drop constraint("time_blocks", :end_hour_is_later_than_star_hour)

    drop index("time_blocks", [:daily_schedule_id], name: "daily_schedule_id_idx")

    drop table("time_blocks")
  end
end
