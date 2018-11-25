defmodule Hadrian.Repo.Migrations.AddComplexesOwners do
  use Ecto.Migration

  def up do
    create table(:complexes_owners) do
      add :email, :string
      add :password_hash, :string
    end

    create unique_index(:complexes_owners, [:email])
  end

  def down do
    drop index(:complexes_owners, :email)
    drop table(:complexes_owners)
  end
end
