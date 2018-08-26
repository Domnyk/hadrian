defmodule Hadrian.Registration do
  alias Ecto.Changeset
  alias Hadrian.Registration.Facebook 
  
  def register_user(attrs \\ %{}, source) do
    case source do
      :in_app -> :error
      :facebook -> Facebook.register(attrs)
      _ -> :error
    end
  end

  @doc """
  Inserts password hash in User changeset
  """
  def insert_password_hash(%Ecto.Changeset{} = changeset) do
    password_hash = Comeonin.Bcrypt.hashpwsalt(changeset.changes.password)
    
    changeset
    |> Changeset.change(password_hash: password_hash)
  end 
end