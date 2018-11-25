defmodule Hadrian.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :varchar, size: 100
      add :display_name, :varchar, size: 50
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:display_name])
  end

  def down do
    drop index(:users, :email)
    drop index(:users, :display_name)
    drop table(:users)
  end
end
