defmodule Hadrian.Repo.Migrations.AddAddressInSportObject do
  use Ecto.Migration

  def change do
    alter table("sport_objects") do
      add :address, :map
    end
  end
end
