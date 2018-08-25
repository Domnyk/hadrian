defmodule Hadrian.Registration.Facebook do
  alias Hadrian.Accounts
  
  @doc """
    Creates user

    Creates user with email and display name from FB data. 
    Password is hardcoded - it is not used during sign in with FB.
  """
  def register(attrs) do
    Accounts.create_user(%{email: attrs["email"], display_name: attrs["name"], password: "Facebook"})
  end
end