defmodule Hadrian.Repo.Migrations.AddRolesTableAlterUsersTable do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :varchar, size: 100
    end

    alter table(:users) do
      add :role_id, references(:roles)
    end
  end
end
