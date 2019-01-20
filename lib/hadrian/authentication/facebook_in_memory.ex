defmodule Hadrian.Authentication.Facebook.InMemory do
  def exchange_code_for_access_token(_code) do
    {:ok, "12345"}
  end

  def get_user(_access_token) do
    {:ok, %{fb_id: "1234567890", name: "Example"}}
  end
end
