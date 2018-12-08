defmodule Hadrian.Repo.Migrations.AddParticipators do
  use Ecto.Migration

  def up do
    create table("participators") do
      add :user_id,               references("users")
      add :event_id,              references("events", on_delete: :delete_all)
      add :has_paid,              :boolean, default: false, null: false
      add :is_event_owner,        :boolean, default: false, null: false
    end

    create index("participators", [:event_id], name: "event_id_idx")
    create index("participators", [:user_id], name: "user_id_idx")
  end

  def down do
    drop index("participators", [:event_id], name: "event_id_idx")
    drop index("participators", [:user_id], name: "user_id_idx")

    drop table("participators")
  end
end
