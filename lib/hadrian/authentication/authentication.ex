defmodule Hadrian.Authentication do
  def verify_password(provided_password, password_hash) do
    case Comeonin.Bcrypt.checkpw(provided_password, password_hash) do
      true -> :match
      false -> :no_match
    end
  end
end
