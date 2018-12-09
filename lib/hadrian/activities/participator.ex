defmodule Hadrian.Activities.Participator do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hadrian.Accounts.User
  alias Hadrian.Activities.Event
  alias Hadrian.Activities.Participator

  schema "participators" do
    field :has_paid, :boolean, default: false
    field :is_event_owner, :boolean, default: false

    belongs_to :user, User
    belongs_to :event, Event
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :event_id, :has_paid, :is_event_owner])
    |> unique_constraint(:user_id, name: :participator_index, message: "can't join to the same event twice")
    |> unique_constraint(:is_event_owner, name: :only_one_owner_index, message: "event can have only one owner")
    |> validate_required([:user_id, :event_id])
  end
end
