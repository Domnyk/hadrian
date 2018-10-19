defmodule Hadrian.Guardian do
  use Guardian, otp_app: :hadrian

  alias Hadrian.Repo
  alias Hadrian.Accounts.User

  def subject_for_token(user = %User{}, _claims) do
    {:ok, "User:#{user.id}"}
  end

  def subject_for_token(_resource, _claims) do
    {:error, "Unkown resource type"}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok, Repo.get(User, id)}
  end

  def resource_from_claims(_) do
    {:error, "Unkown resource type"}
  end
end