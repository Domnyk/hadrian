defmodule Hadrian.Activities.Participation do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Ecto.Query
  alias Hadrian.Repo
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
    |> validate_change(:event_id, &is_num_of_participants_exceeded/2)
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

  defp is_num_of_participants_exceeded(:event_id, value) do
    event = Activities.get_event!(value)
    new_num_of_participators = get_num_of_participators(event) + 1

    case (new_num_of_participators > event.max_num_of_participants) do
      true -> [max_num_of_participants: "reached max number of participators"]
      false -> []
    end
  end

  defp get_num_of_participators(%Event{id: id} = event) do
    Repo.one(from p in "participations", where: p.event_id == ^id, select: count(p.id))
  end
end
