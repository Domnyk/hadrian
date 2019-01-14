defmodule Hadrian.Accounts.ComplexesOwner do
  use Ecto.Schema
  import Ecto.Changeset

  # Based on: https://gist.github.com/corpsee/4264638
  @email ~r/^[\p{L}\p{Nd}]{1}([-\p{L}\p{Nd}_]+[\.]{0,2}[+]?)+@([-\p{L}\p{Nd}_]{1,}\.)+[\p{L}\p{Nd}]{2,4}$/xiu
  @password ~r/\d[a-z][A-Z][\W_]/

  schema "complexes_owners" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :paypal_email, :string

    has_many :sport_complexes, Hadrian.Owners.SportComplex, foreign_key: :complexes_owner_id
  end

  @doc false
  def changeset(complexes_owner, attrs) do
    complexes_owner
    |> cast(attrs, [:email, :password, :paypal_email])
    |> validate_required([:email, :password, :paypal_email])
    |> unique_constraint(:email)
    |> unique_constraint(:paypal_email)
    |> validate_format(:email, @email)
    |> validate_format(:paypal_email, @email)
    |> validate_length(:password, min: 8)
    |> validate_format(:password, @password)
    |> maybe_insert_hash_password()
  end

  def update_changeset(complexes_owner, attrs) do
    complexes_owner
    |> cast(attrs, [:email, :paypal_email])
    |> validate_required([:email, :paypal_email])
    |> unique_constraint(:email)
    |> unique_constraint(:paypal_email)
    |> validate_format(:email, @email)
    |> validate_format(:paypal_email, @email)
  end

  defp maybe_insert_hash_password(changeset) do
    if changeset.valid? && Map.has_key?(changeset.changes, :password) do
      password_hash = Comeonin.Bcrypt.hashpwsalt(changeset.changes.password)
      Ecto.Changeset.change(changeset, password_hash: password_hash)
    else
      changeset
    end
  end
end
