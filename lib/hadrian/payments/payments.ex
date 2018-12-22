defmodule Hadrian.Payments do
  alias Hadrian.Payments.Token
  alias Hadrian.Payments.Payment
  alias Hadrian.Activities.Participation

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
         map = %{token: _, urls: _} -> {:ok, map}
         _ -> :error
       end
  end

  def get_payment_approval_address(participation = %Participation{}) do
    participation.payment_approve_url
  end

  def get_payment_approval_address(participation) do
    msg = ~s(Wrong type of arguments. \n participation: #{inspect(participation)})
    raise ArgumentError, message: msg
  end

  def execute_payment(participation = %Participation{}, token) do
    case Payment.execute(participation.payment_execute_url, participation.payer_id, token) do
      token when is_binary(token) -> {:ok, token}
      _ -> :error
    end
  end
end
