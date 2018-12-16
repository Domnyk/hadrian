defmodule Hadrian.Payments do
  alias Hadrian.Payments.Token
  alias Hadrian.Payments.Payment

  def fetch_token() do
    client_id = System.get_env("PAYPAL_CLIENT_ID")
    secret = System.get_env("PAYPAL_SECRET")

    Token.fetch(client_id, secret)
  end

  def create_payment(token, attrs) when is_binary(token) and is_map(attrs) do
    Payment.changeset(%Payment{}, attrs)
    |> Ecto.Changeset.apply_changes()
    |> Payment.create(token)
    |> case do
         map = %{token: token, urls: urls} -> {:ok, %{token: token, urls: urls}}
         _ -> :error
       end
  end

  def get_payment_approval_address(token) do

  end

  def execute_payment(token) do

  end
end
