defmodule Hadrian.Repo.Migrations.AddSportObjects do
  use Ecto.Migration

  def up do
    create table(:sport_objects) do
      add :name,              :varchar, size: 100
      add :longitude,         :decimal, precision: 9, scale: 6
      add :latitude,          :decimal, precision: 8, scale: 6
      add :geo_coordinates,   :map
      add :address,           :map
      add :booking_margin,    :interval
      add :sport_complex_id,  references(:sport_complexes)
    end

    create index(:sport_objects, [:sport_complex_id], [name: :sport_complex_id_idx])

    create unique_index(:sport_objects, [:name], [name: :sport_object_name_idx])
  end

  def down do
    drop index(:sport_objects, [:name], name: :sport_object_name_idx)
    drop index(:sport_objects, [:sport_complex_id], name: :sport_complex_id_idx)
    drop table(:sport_objects)
  end
end
