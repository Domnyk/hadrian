defmodule Hadrian.Repo.Migrations.AlterPasswordHashInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :password_hash, :string
    end
  end
end
