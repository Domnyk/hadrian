defmodule Hadrian.Repo.Migrations.AddComplexes do
  use Ecto.Migration

  def up do
    create table("sport_complexes") do
      add :name, :string, size: 100
    end
  end

  def down do
    drop table("sport_complexes")
  end
end

