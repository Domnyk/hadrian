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

  # TODO: Add plug to check whether payment can be approved and executed or not

  action_fallback HadrianWeb.Api.FallbackController

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
