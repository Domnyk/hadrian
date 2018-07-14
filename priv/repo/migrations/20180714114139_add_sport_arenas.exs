defmodule Hadrian.Repo.Migrations.AddSportArenas do
  use Ecto.Migration

  def up do
    create table("sport_arenas") do
      add :name,            :varchar, size: 100
      add :type,            :varchar, size: 100
      add :sport_object_id, references("sport_objects")
    end

    create index("sport_arenas", [:sport_object_id], [name: "sport_object_id_idx"])
  end

  def down do
    drop index("sport_arenas", [:sport_object_id], [name: "sport_object_id_idx"])

    drop table("sport_arenas")
  end
end
