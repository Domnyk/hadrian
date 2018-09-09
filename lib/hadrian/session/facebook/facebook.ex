defmodule Hadrian.Session.Facebook do
  alias Hadrian.Repo
  alias Hadrian.Accounts
  alias Hadrian.Accounts.User  
  
  @access_token Application.get_env(:hadrian, :access_token)

  def login(params) do
    user = Repo.get_by(User, email: String.downcase(params["email"]))

    valid_user_data? = user != nil and @access_token.valid?(params)
    case valid_user_data? do
      false -> {:error, params}
      true -> {:ok, user}
    end
  end
end
