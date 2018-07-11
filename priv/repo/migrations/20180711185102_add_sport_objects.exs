defmodule Hadrian.Repo.Migrations.AddSportObjects do
  use Ecto.Migration

  def up do
    create table("sport_objects") do
      add :name,            :varchar, size: 100
      add :longitude,       :decimal, precision: 9, scale: 6
      add :latitude,        :decimal, precision: 8, scale: 6
      add :booking_margin,  :interval
    end

    create unique_index("sport_objects", [:longitude, :latitude])
    create unique_index("sport_objects", [:name])
  end

  def down do
    drop table("sport_objects")
  end
end
