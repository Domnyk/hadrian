defmodule Hadrian.Payments do
  alias Hadrian.Payments.Token

  def fetch_token() do
    client_id = System.get_env("PAYPAL_CLIENT_ID")
    secret = System.get_env("PAYPAL_SECRET")

    Token.fetch(client_id, secret)
  end

  def create_payment(token, attrs) when is_binary(token) and is_map(attrs) do

  end

  def get_payment_approval_address(token) do

  end

  def execute_payment(token) do

  end
end
