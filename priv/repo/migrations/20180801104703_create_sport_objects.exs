defmodule Hadrian.Repo.Migrations.CreateSportObjects do
  use Ecto.Migration

  def change do
    create table(:sport_objects) do
      add :name, :string
      add :longitude, :decimal
      add :latitude, :decimal
      add :name, :string

      timestamps()
    end

  end
end
