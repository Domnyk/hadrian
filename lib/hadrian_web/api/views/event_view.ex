defmodule HadrianWeb.Api.EventView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("index.json", %{events_with_participations: events_with_participations}) do
    events_with_participations
    |> Enum.map(fn {event, participations} -> render("event.json", event: event, participations: participations) end)
  end

  def render("event.json", %{event: event, participations: participations}) do
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
      sport_arena_id: event.sport_arena_id,
      participators: render_participators(event.participators, participations)
    }
  end

  defp render_participators(participators, participations) do
    sorted_participators = Enum.sort(participators, fn p_1, p_2 -> p_1.id < p_2.id end)
    sorted_participations = Enum.sort(participations, fn p_1, p_2 -> p_1.id < p_2.id end)

    Enum.zip(sorted_participators, sorted_participations)
    |> Enum.reduce([], fn {participator, participation}, acc ->
         acc ++ [render_participator(participator, participation)]
       end)
  end

  alias Hadrian.Accounts.User
  alias Hadrian.Activities.Participation

  defp render_participator(%User{} = participator, %Participation{} = participation) do
    %{
      id: participator.id,
      email: participator.email,
      display_name: participator.display_name,
      has_paid: participation.has_paid,
      is_event_owner: participation.is_event_owner}
  end
end
