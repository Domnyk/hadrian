defmodule Hadrian.Activities.Participation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hadrian.Activities
  alias Hadrian.Activities.Event

  schema "participations" do
    field :has_paid, :boolean, default: false
    field :is_event_owner, :boolean, default: false
    field :payment_approve_url, :string
    field :payment_execute_url, :string
    field :payer_id,            :string

    belongs_to :user, Hadrian.Accounts.User
    belongs_to :event, Event
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :event_id, :has_paid, :is_event_owner, :payment_approve_url, :payment_execute_url,
                    :payer_id])
    |> unique_constraint(:user_id, name: :participation_index, message: "can't join to the same event twice") # This unique constraint uses database index which consists of user_id and event_id
    |> validate_change(:event_id, &join_if_time_is_appropriate/2)
    |> validate_required([:user_id, :event_id])
  end

  defp join_if_time_is_appropriate(:event_id, value) do
    current_day = Date.utc_today()
    %Event{end_of_joining_phase: end_of_joining_phase} = Activities.get_event!(value)

    case Date.compare(current_day, end_of_joining_phase) do
      :gt -> [end_of_joining_phase: "joining phase has ended already"]
      _ -> []
    end
  end
end
