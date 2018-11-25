defmodule Hadrian.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :display_name, :string

    many_to_many :events, Hadrian.Activities.Event, join_through: "users_in_events"
  end

  @doc false
  def changeset(user, attrs) do
    # Based on: https://gist.github.com/corpsee/4264638
    email = ~r/^[\p{L}\p{Nd}]{1}([-\p{L}\p{Nd}_]+[\.]{0,2}[+]?)+@([-\p{L}\p{Nd}_]{1,}\.)+[\p{L}\p{Nd}]{2,4}$/xiu

    user
    |> cast(attrs, [:email, :display_name])
    |> unique_constraint(:email)
    |> unique_constraint(:display_name)
    |> validate_format(:email, email)
    |> validate_required([:email, :display_name])
  end
end