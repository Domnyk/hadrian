defmodule Hadrian.Repo.Migrations.AddComplexesOwners do
  use Ecto.Migration

  def up do
    create table(:complexes_owners) do
      add :email, :varchar, size: 100
      add :password_hash, :string
      add :paypal_email, :varchar, size: 100
    end

    create unique_index(:complexes_owners, [:email])
    create unique_index(:complexes_owners, [:paypal_email])
  end

  def down do
    drop index(:complexes_owners, :email)
    drop table(:complexes_owners)
  end
end
