defmodule Hadrian.Repo.Migrations.AddParticipations do
  use Ecto.Migration

  def up do
    create table(:participations) do
      add :user_id,               references(:users)
      add :event_id,              references(:events, on_delete: :delete_all)
      add :has_paid,              :boolean, default: false, null: false
      add :is_event_owner,        :boolean, default: false, null: false
      add :payment_approve_url,   :varchar, size: 200
      add :payment_execute_url,   :varchar, size: 200
      add :payer_id,              :varchar, size: 200
    end

    create unique_index(:participations, [:user_id, :event_id], name: :participation_index)
    create index(:participations, :event_id)
  end

  def down do
    drop unique_index(:participations, [:user_id, :event_id], name: :participation_index)
    drop index(:participations, :event_id)

    drop table(:participations)
  end
end
