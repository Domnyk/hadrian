defmodule Hadrian.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :login, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :display_name, :string

    many_to_many :events, Hadrian.Activities.Event, join_through: "users_in_events"
  end

  @doc false
  def changeset(user, attrs) do
    alphanum_or_blank = ~r/^(\A\z|\w+)$/
    email = ~r/^[\p{L}\p{Nd}]{1}([-\p{L}\p{Nd}_]+[\.]{0,2}[+]?)+@([-\p{L}\p{Nd}_]{1,}\.)+[\p{L}\p{Nd}]{2,4}$/xiu

    user
    |> cast(attrs, [:login, :password, :password_hash, :email, :display_name])
    |> validate_confirmation(:password, message: "does not match password")
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> validate_format(:login, alphanum_or_blank)
    |> validate_format(:display_name, alphanum_or_blank)
    |> validate_format(:email, email)
    |> validate_required([:password, :email])
  end
end