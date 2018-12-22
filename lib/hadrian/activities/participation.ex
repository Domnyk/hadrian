defmodule Hadrian.Activities.Participation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hadrian.Accounts.User
  alias Hadrian.Activities.Event

  schema "participations" do
    field :has_paid, :boolean, default: false
    field :is_event_owner, :boolean, default: false
    field :payment_approve_url, :string
    field :payment_execute_url, :string
    field :payer_id,            :string

    belongs_to :user, User
    belongs_to :event, Event
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :event_id, :has_paid, :is_event_owner, :payment_approve_url, :payment_execute_url,
                    :payer_id])
    |> unique_constraint(:user_id, name: :participation_index, message: "can't join to the same event twice")
    |> validate_required([:user_id, :event_id])
  end
end
