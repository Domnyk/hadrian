defmodule Hadrian.Security do
  def authenticate(user_from_db, provided_password) when not is_nil(user_from_db) do
    case Comeonin.Bcrypt.checkpw(provided_password, user_from_db.password_hash) do
      true -> {:ok, user_from_db}
      false -> {:error, "Password missmatch"}
    end
  end
end