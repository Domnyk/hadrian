defmodule Hadrian.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :first_name
      remove :last_name

      add :login, :varchar, size: 50, null: true
      add :password_hash, :varchar, size: 50
      add :email, :varchar, size: 100
      add :display_name, :varchar, size: 50, null: true
    end
  end
end
