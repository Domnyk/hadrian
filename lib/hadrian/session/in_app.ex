defmodule Hadrian.Session.InApp do
  alias Hadrian.Repo
  alias Hadrian.Accounts.User
  
  def authenticate(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.password_hash)
    end
  end

  def login(params) do
    user = Repo.get_by(User, email: String.downcase(params["email"]))

    case authenticate(user, params["password"]) do
      true  -> {:ok, user}
      _     -> :error
    end
  end
end