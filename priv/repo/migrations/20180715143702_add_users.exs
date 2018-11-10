defmodule Hadrian.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :login, :varchar, size: 50, null: true
      add :password_hash, :string
      add :email, :varchar, size: 100
      add :display_name, :varchar, size: 50, null: true
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop index(:users, :email)
    drop table(:users)
  end
end
