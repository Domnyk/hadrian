defmodule Hadrian.Registration.Facebook do
  alias Hadria.Accounts
  
  def register(attrs) do
    Accounts.create_user(%{email: attrs["email"], display_name: attrs["name"]})
  end
end