defmodule HadrianWeb.Api.Plugs.ValidatePaymentTime do
  import Plug.Conn

  alias Hadrian.Activities
  alias Hadrian.Activities.Event
  alias HadrianWeb.Api.Helpers.Session

  def init(opts) do

  end

  def call(%Plug.Conn{path_params: %{"event_id" => event_id}} = conn, _opts) do
    event = Activities.get_event!(event_id)

    case valid_payment_time?(event) do
      true -> conn
      false -> handle_invalid_payment_time(conn)
    end
  end

  defp valid_payment_time?(%Event{end_of_joining_phase: end_1, end_of_paying_phase: end_2} = event) do
    now = Date.utc_today()

    payment_after_joining_phase?(now, end_1) && payment_before_payment_phase_end?(now, end_2)
  end

  defp payment_after_joining_phase?(%Date{} = now, %Date{} = end_of_joining_phase) do
    case Date.compare(now, end_of_joining_phase) do
      :lt -> false
      _ -> true
    end
  end

  defp payment_before_payment_phase_end?(%Date{} = now, %Date{} = end_of_paying_phase) do
    case Date.compare(now, end_of_paying_phase) do
      :gt -> false
      _ -> true
    end
  end

  defp handle_invalid_payment_time(conn) do
    conn
    |> put_status(:bad_request)
    |> Phoenix.Controller.render(HadrianWeb.Api.InvalidPaymentView, :payment_in_join_phase)
    |> halt()
  end
end
