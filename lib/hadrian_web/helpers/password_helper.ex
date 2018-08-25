defmodule HadrianWeb.Api.PasswordHelper do
  def create_hash(phrase) do
    Comeonin.Bcrypt.hashpwsalt(phrase)
  end
end