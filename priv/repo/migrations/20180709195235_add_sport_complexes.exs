defmodule Hadrian.Repo.Migrations.AddSportComplexes do
  use Ecto.Migration

  def up do
    create table("sport_complexes") do
      add :name, :string, size: 100
    end

    create unique_index("sport_complexes", [:name], name: "sport_complex_name_idx")
  end

  def down do
    drop index("sport_complexes", [:name], name: "sport_complex_name_idx")

    drop table("sport_complexes")
  end
end

