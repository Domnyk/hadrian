defmodule Hadrian.Registration.InApp do
  alias Hadrian.Accounts
  
  def register(attrs) do
    password = Map.get(attrs, "password")
    
    attrs
    |> Map.put("password_hash", create_hash(password))
    |> Accounts.create_user()
  end

  @doc """
  Calculates hash for given phrase.
  """
  defp create_hash(phrase) do
    Comeonin.Bcrypt.hashpwsalt(phrase)
  end
end