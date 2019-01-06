defmodule Hadrian.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hadrian.Activities.Participation

  schema "users" do
    field :fb_id, :string
    field :display_name, :string
    field :paypal_email, :string

    many_to_many :events, Hadrian.Activities.Event, join_through: Participation
  end

  @doc false
  def changeset(user, attrs) do
    # Based on: https://gist.github.com/corpsee/4264638
    email = ~r/^[\p{L}\p{Nd}]{1}([-\p{L}\p{Nd}_]+[\.]{0,2}[+]?)+@([-\p{L}\p{Nd}_]{1,}\.)+[\p{L}\p{Nd}]{2,4}$/xiu

    user
    |> cast(attrs, [:fb_id, :display_name, :paypal_email])
    |> unique_constraint(:fb_id)
    |> unique_constraint(:display_name)
    |> validate_format(:paypal_email, email)
    |> validate_required([:fb_id, :display_name, :paypal_email])
  end
end