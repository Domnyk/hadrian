defmodule Hadrian.Repo.Migrations.AddParticipators do
  use Ecto.Migration

  def up do
    create table(:participators) do
      add :user_id,               references(:users)
      add :event_id,              references(:events, on_delete: :delete_all)
      add :has_paid,              :boolean, default: false, null: false
      add :is_event_owner,        :boolean, default: false, null: false
    end

    create unique_index(:participators, [:user_id, :event_id], name: :participator_index)
    create unique_index(:participators, [:is_event_owner], where: "is_event_owner = true", name: :only_one_owner_index)
    create index(:participators, :event_id)
  end

  def down do
    drop unique_index(:participators, [:user_id, :event_id], name: :participator_index)
    drop unique_index(:participators, [:is_event_owner], name: :only_one_owner_index)
    drop index(:participators, :event_id)

    drop table(:participators)
  end
end
