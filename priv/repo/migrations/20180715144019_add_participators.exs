defmodule Hadrian.Repo.Migrations.AddParticipations do
  use Ecto.Migration

  def up do
    create table(:participations) do
      add :user_id,               references(:users)
      add :event_id,              references(:events, on_delete: :delete_all)
      add :has_paid,              :boolean, default: false, null: false
      add :is_event_owner,        :boolean, default: false, null: false
    end

    create unique_index(:participations, [:user_id, :event_id], name: :participation_index)
    create unique_index(:participations, [:is_event_owner], where: "is_event_owner = true", name: :only_one_owner_index)
    create index(:participations, :event_id)
  end

  def down do
    drop unique_index(:participations, [:user_id, :event_id], name: :participation_index)
    drop unique_index(:participations, [:is_event_owner], name: :only_one_owner_index)
    drop index(:participations, :event_id)

    drop table(:participations)
  end
end
