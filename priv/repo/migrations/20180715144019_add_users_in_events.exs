defmodule Hadrian.Repo.Migrations.AddUsersInEvents do
  use Ecto.Migration

  def up do
    create table("users_in_events") do
      add :user_id,               references("users")
      add :event_id,              references("events")
      add :is_ready,              :boolean
      add :has_pad,               :boolean
      add :is_user_events_owner,  :boolean
    end

    create index("users_in_events", [:event_id], name: "event_id_idx")
  end

  def down do
    drop index("users_in_events", [:event_id], name: "event_id_idx")

    drop table("users_in_events")
  end
end
