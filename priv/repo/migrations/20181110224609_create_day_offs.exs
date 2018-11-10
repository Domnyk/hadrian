defmodule Hadrian.Repo.Migrations.CreateDayOffs do
  use Ecto.Migration

  def up do
    create table(:day_offs) do
      add :date,  :date
      add :daily_schedule_id, references(:daily_schedules)
    end
  end

  def down do
    drop table(:day_offs)
  end
end
