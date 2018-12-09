defmodule HadrianWeb.Api.ParticipationController do
  use HadrianWeb, :controller

  require Logger

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

  def delete(conn, %{"event_id" => event_id}) do
    current_user_id = get_session(conn, :current_user_id)
    with %Participation{} = participation <- Activities.get_participation!(event_id, current_user_id),
         {:ok, %Participation{}} <- Activities.delete_participation(participation)
    do
      send_resp(conn, :no_content, "")
    end
  end
end
