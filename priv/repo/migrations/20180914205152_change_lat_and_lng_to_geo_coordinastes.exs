defmodule Hadrian.Repo.Migrations.ChangeLatAndLngToGeoCoordinastes do
  use Ecto.Migration

  def change do
    alter table("sport_objects") do
      remove :latitude
      remove :longitude
      add :geo_coordinates, :map
    end
  end
end
