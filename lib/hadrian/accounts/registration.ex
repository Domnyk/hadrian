defmodule Hadrian.Accounts.Registration do
  @doc """
  Calculates hash for given phrase.
  """
  def create_hash(phrase) do
    Comeonin.Bcrypt.hashpwsalt(phrase)
  end
end