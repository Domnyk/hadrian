defmodule HadrianWeb.Api.ParticipationController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Owners
  alias Hadrian.Accounts
  alias Hadrian.Payments
  alias HadrianWeb.Api.Helpers.Session
  alias Hadrian.PayPalStorage
  alias Hadrian.Activities
  alias Hadrian.Activities.Participation

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"event_id" => event_id}) do
    participations = Activities.list_participations(event_id)
    render(conn, "index.json", participations: participations)
  end

  def create(conn, %{"event_id" => event_id}) do
    event = Activities.get_event!(event_id)
    new_participation = Accounts.get_user!(get_session(conn, :current_user_id))

    with {:ok, %Participation{} = participation} <- Activities.create_participation(event, new_participation),
         :ok <- create_payment(participation) do
      conn
      |> put_status(:created)
      |> render("show.json", participation: participation)
    end
  end

  def pay(conn, %{"event_id" => event_id}) do
    current_user_id = Session.get_user_id(conn)
    participation = Activities.get_participation!(event_id, current_user_id)

    redirect(conn, external: Payments.get_payment_approval_address(participation))
  end

  defp create_payment(%Participation{} = participation) do
    token = Hadrian.PayPalStorage.get_token()
      user = Accounts.get_user!(participation.user_id)
      sport_object =
        Activities.get_event!(participation.event_id)
        |> Map.get(:sport_arena_id)
        |> Owners.get_sport_arena!()
        |> Map.get(:sport_object_id)
        |> Owners.get_sport_object!()

      owner =
        Owners.get_sport_complex!(sport_object.sport_complex_id)
        |> Map.get(:complexes_owner_id)
        |> Accounts.get_complexes_owner!()

      attrs = %{ sport_object_name: sport_object.name, amount_to_pay: 10, complexes_owner_email: owner.email,
        return_url: "https://localhost:8080", cancel_url: "https://localhost:8080", payer_email: user.email }

      with {:ok, %{token: token, urls: %{approval: approval, execute: execute}}} <- Payments.create_payment(token, attrs),
           {:ok, %Participation{}} <- Activities.update_participation(participation, %{payment_approve_url: approval, payment_execute_url: execute}) do
        PayPalStorage.put_token(token)
        :ok
    end
  end

  def delete(conn, %{"event_id" => event_id}) do
    current_user_id = get_session(conn, :current_user_id)
    with %Participation{} = participation <- Activities.get_participation!(event_id, current_user_id),
         {:ok, %Participation{}} <- Activities.delete_participation(participation)
    do
      conn
      |> put_status(:ok)
      |> render("show.json", participation: participation)
    end
  end
end
