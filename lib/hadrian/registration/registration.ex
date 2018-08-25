defmodule Hadrian.Registration do
  alias Hadrian.Accounts
  alias Hadrian.Registration.InApp
  alias Hadrian.Registration.Facebook
  
  def register_user(attrs \\ %{}, source) do
    case source do
      :in_app -> InApp.register(attrs)
      :facebook -> Facebook.register(attrs)
      _ -> :error
    end
  end
end