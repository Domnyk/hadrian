defmodule Hadrian.Session.Facebook do
  alias Hadrian.Repo
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User

  def login(params) do
    user = Repo.get_by(User, email: String.downcase(params["email"]))

    case user do
      nil -> Accounts.create_user(%{email: params["email"], display_name: params["name"]})
      _ -> {:ok, user}
    end
  end
end
