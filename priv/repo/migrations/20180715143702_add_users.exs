defmodule Hadrian.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :fb_id, :varchar, size: 100
      add :display_name, :varchar, size: 50
      add :paypal_email, :varchar, size: 100
    end

    create unique_index(:users, [:fb_id])
    create unique_index(:users, [:display_name])
  end

  def down do
    drop index(:users, :fb_id)
    drop index(:users, :display_name)
    drop table(:users)
  end
end
