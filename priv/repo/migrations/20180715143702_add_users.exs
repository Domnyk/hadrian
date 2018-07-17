defmodule Hadrian.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def up do
    create table("users") do
      add :first_name, :varchar, size: 50
      add :last_name,  :varchar, size: 50
    end


  end

  def down do
    drop table("users")  
  end
end
