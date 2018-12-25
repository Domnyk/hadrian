defmodule HadrianWeb.Api.PaymentController do
  use HadrianWeb, :controller

  require Logger

  alias HadrianWeb.Endpoint
  alias Hadrian.Activities
  alias Hadrian.Activities.Participation
  alias Hadrian.Owners
  alias Hadrian.Owners.SportObject
  alias Hadrian.Accounts
  alias Hadrian.Accounts.ComplexesOwner
  alias Hadrian.Accounts.User
  alias Hadrian.Payments
  alias Hadrian.PaypalStorage
  alias HadrianWeb.Api.Helpers.Session

  action_fallback HadrianWeb.Api.FallbackController

  def create(conn, %{"event_id" => event_id}) do
    token = PaypalStorage.get_token()
    participation = Activities.get_participation!(event_id, Session.get_user_id(conn))
    user = Accounts.get_user!(participation.user_id)
    object = get_object!(event_id)
    owner = get_owner!(object.sport_complex_id)
    attrs = create_payment_attrs(object, owner, user, event_id)

    with {:ok, %{token: token, urls: urls}} <- Payments.create_payment(token, attrs),
         {:ok, %Participation{}} <- update_participation(participation, urls) do
      PaypalStorage.put_token(token)
    end
  end

  defp update_participation(%Participation{} = participation, urls) when is_map(urls) do
    %{approval: a, execute: e} = urls
    Activities.update_participation(participation, %{payment_approve_url: a, payment_execute_url: e})
  end

  defp create_payment_attrs(%SportObject{} = object, %ComplexesOwner{} = payee, %User{} = payer, event_id) do
    return_url = HadrianWeb.Endpoint.url <> event_payment_path(Endpoint, :execute, event_id)

    attrs = %{sport_object_name: object.name, amount_to_pay: 10, complexes_owner_email: payee.email,
              return_url: return_url, cancel_url: "https://localhost:8080", payer_email: payer.email}
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

  def approve(conn, %{"event_id" => event_id}) do
    current_user_id = Session.get_user_id(conn)
    participation = Activities.get_participation!(event_id, current_user_id)

    redirect(conn, external: Payments.get_payment_approval_address(participation))
  end

  def execute(conn, %{"event_id" => event_id, "PayerID" => payer_id}) do
    token = Hadrian.PaypalStorage.get_token()
    participation = Activities.get_participation!(event_id, Session.get_user_id(conn))
    {:ok, participation} = Activities.update_participation(participation, %{payer_id: payer_id})

    with {:ok, token} <- Payments.execute_payment(participation, token) do
      Logger.info("Payment has been executed")

      Activities.update_participation(participation, %{has_paid: true})
      redirect_url = Application.get_env(:hadrian, :client_url) <> "/payment?status=success"
      PaypalStorage.put_token(token)
      redirect(conn, external: redirect_url)
    end
  end
end
