defmodule Hadrian.Guardian do
  use Guardian, otp_app: :hadrian

  alias Hadrian.Repo
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User

  def for_token(user = %User{}) do
    {:ok, "User:#{user.id}"}
  end

  def for_token(_) do
    {:error, "Unkown resource type"}
  end

  def from_claims(claims) do
    id = claims["sub"]
    {:ok, Repo.get(User, id)}
  end

  def from_claims(_) do
    {:error, "Unkown resource type"}
  end
end