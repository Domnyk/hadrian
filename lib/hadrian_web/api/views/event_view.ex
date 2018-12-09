defmodule HadrianWeb.Api.EventView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("index.json", %{events_with_participators: events_with_participators}) do
    events_with_participators
    |> Enum.map(fn {event, participators} -> render("event.json", event: event, participators: participators) end)
  end

  def render("event.json", %{event: event, participators: participators}) do
    %{
      id: event.id,
      name: event.name,
      max_num_of_participants: event.max_num_of_participants,
      min_num_of_participants: event.min_num_of_participants,
      event_day: event.event_day,
      end_of_joining_phase: event.end_of_joining_phase,
      end_of_paying_phase: event.end_of_paying_phase,
      start_time: event.start_time,
      end_time: event.end_time,
      participators: render_participators(event.participators, participators)
    }
  end

  defp render_participators(users, participators) do
    sorted_users = Enum.sort(users, fn user_1, user_2 -> user_1.id < user_2.id end)
    sorted_participators = Enum.sort(participators, fn p_1, p_2 -> p_1.id < p_2.id end)

    Enum.zip(sorted_users, sorted_participators)
    |> Enum.reduce([], fn {user, participator}, acc ->
         acc ++ [render_participator(user, participator)]
       end)
  end

  alias Hadrian.Accounts.User
  alias Hadrian.Activities.Participator

  defp render_participator(%User{} = user, %Participator{} = participator) do
    %{
      id: user.id,
      email: user.email,
      display_name: user.display_name,
      has_paid: participator.has_paid,
      is_event_owner: participator.is_event_owner}
  end
end
