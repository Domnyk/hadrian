defmodule Hadrian.Repo.Migrations.CreateSportsDisciplines do
  use Ecto.Migration

  def up do
    create table(:sports_disciplines) do
      add :name, :string
      add :min_num_of_people, :integer
      add :required_equipment, :string

      timestamps()
    end
  end
  
  def down do
    	drop table(:sports_disciplines)
    end
end
