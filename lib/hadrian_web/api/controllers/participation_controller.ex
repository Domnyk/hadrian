defmodule HadrianWeb.Api.ParticipationController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Owners
  alias Hadrian.Accounts
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

    with {:ok, %Participation{} = participation} <- Activities.create_participation(event, new_participation)
    do
      conn
      |> put_status(:created)
      |> render("show.json", participation: participation)
    end
  end

  defp create_payment(token, %Participation{} = participation) when is_binary(token) do
    user = Accounts.get_user!(participation.user_id)
    sport_object =
      Activities.get_event!(participation.event_id)
      |> Map.get(:sport_arena_id)
      |> Owners.get_sport_arena!()
      |> Map.get(:sport_object_id)
      |> Owners.get_sport_object!()

    attrs = %{ payer_email: user.email, sport_object_name: sport_object.name }
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
