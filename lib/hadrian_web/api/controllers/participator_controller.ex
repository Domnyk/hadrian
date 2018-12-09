defmodule HadrianWeb.Api.ParticipatorController do
  use HadrianWeb, :controller

  require Logger

  alias Hadrian.Accounts
  alias Hadrian.Activities
  alias Hadrian.Activities.Participator

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"event_id" => event_id}) do
    participators = Activities.list_participators(event_id)
    render(conn, "index.json", participators: participators)
  end

  def create(conn, %{"event_id" => event_id}) do
    event = Activities.get_event!(event_id)
    new_participator = Accounts.get_user!(get_session(conn, :current_user_id))

    with {:ok, %Participator{} = participator} <- Activities.create_participator(event, new_participator)
    do
      conn
      |> put_status(:created)
      |> render("show.json", participator: participator)
    end
  end

  def delete(conn, %{"event_id" => event_id}) do
    current_user_id = get_session(conn, :current_user_id)
    with %Participator{} = participator <- Activities.get_participator!(event_id, current_user_id),
         {:ok, %Participator{}} <- Activities.delete_participator(participator)
    do
      send_resp(conn, :no_content, "")
    end
  end
end
