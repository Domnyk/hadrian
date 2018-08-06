defmodule Hadrian.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name , :string
    field :last_name  , :string

    many_to_many :events, Hadrian.Activities.Event, join_through: "users_in_events"
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end
