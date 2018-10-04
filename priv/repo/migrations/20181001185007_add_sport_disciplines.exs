defmodule Hadrian.Repo.Migrations.AddSportDisciplines do
  use Ecto.Migration

  def up do
    create table("sport_disciplines") do
      add :name, :varchar, size: 100
    end
  end

  def down do
    drop table("sport_disciplines")
  end
end
