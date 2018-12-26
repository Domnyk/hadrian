defmodule Hadrian.Payments do
  require Logger

  alias Hadrian.Payments.Token
  alias Hadrian.Payments.Payment
  alias Hadrian.Activities
  alias Hadrian.Activities.Participation
  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject
  alias Hadrian.Accounts
  alias Hadrian.Accounts.ComplexesOwner
  alias Hadrian.Accounts.User
  alias Hadrian.PaypalStorage
  alias HadrianWeb.Router.Helpers
  alias HadrianWeb.Endpoint

  def fetch_token() do
    client_id = System.get_env("PAYPAL_CLIENT_ID")
    secret = System.get_env("PAYPAL_SECRET")

    Token.fetch(client_id, secret)
  end

  def create_payment(%Participation{} = participation) do
    token = PaypalStorage.get_token()
    user = Accounts.get_user!(participation.user_id)
    object = get_object!(participation.event_id)
    owner = get_owner!(object.sport_complex_id)
    attrs = create_payment_attrs(object, owner, user, participation.event_id)

    Payment.changeset(%Payment{}, attrs)
    |> Ecto.Changeset.apply_changes()
    |> Payment.create(token)
    |> case do
         %{token: token, urls: urls} ->
           PaypalStorage.put_token(token)
           update_participation(participation, urls)
         _ -> :error
       end
  end

  defp create_payment_attrs(%SportObject{} = object, %ComplexesOwner{} = payee, %User{} = payer, event_id) do
    return_url = Endpoint.url <> Helpers.event_payment_path(Endpoint, :execute, event_id)

    attrs = %{sport_object_name: object.name, amount_to_pay: 10, complexes_owner_email: payee.paypal_email,
              return_url: return_url, cancel_url: "https://localhost:8080", payer_email: payer.paypal_email}

    Logger.info ~s(Payment attrs \n #{inspect(attrs)})

    attrs
  end

  defp get_object!(event_id) do
    Activities.get_event!(event_id)
    |> Map.get(:sport_arena_id)
    |> Owners.get_sport_arena!()
    |> Map.get(:sport_object_id)
    |> Owners.get_sport_object!()
  end

  defp get_owner!(complex_id) do
    Owners.get_sport_complex!(complex_id)
    |> Map.get(:complexes_owner_id)
    |> Accounts.get_complexes_owner!()
  end

  defp update_participation(%Participation{} = participation, urls) when is_map(urls) do
    %{approval: a, execute: e} = urls
    Activities.update_participation(participation, %{payment_approve_url: a, payment_execute_url: e})
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
