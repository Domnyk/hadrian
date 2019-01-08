defmodule Hadrian.Owners.SportArena do
	use Ecto.Schema
	import Ecto.Changeset
	alias Hadrian.Owners.SportDiscipline
  alias Hadrian.Repo
  alias Hadrian.Owners.SportArena

  @open_time ~T[06:00:00.000000]
  @close_time ~T[23:00:00.000000]

  schema "sport_arenas" do
    field :name, :string
    field :price_per_hour, :float

		belongs_to :sport_object, Hadrian.Owners.SportObject, references: :id
		has_many :events, Hadrian.Activities.Event, foreign_key: :sport_arena_id
		many_to_many :sport_disciplines, SportDiscipline, join_through: "sport_disciplines_in_sport_arenas",
                                                      on_replace: :delete
	end

  @doc false
  def changeset(sport_arena, attrs) do
    sport_arena
    |> Repo.preload(:sport_disciplines)
    |> cast(attrs, [:name, :price_per_hour, :sport_object_id])
    |> foreign_key_constraint(:sport_object_id)
    |> validate_required([:name, :price_per_hour, :sport_object_id])
    |> validate_number(:price_per_hour, greater_than_or_equal_to: 0.0)
    |> put_assoc(:sport_disciplines, parse_sport_disciplines(attrs))
  end

  defp parse_sport_disciplines(attrs) do
    (attrs["sport_disciplines"] || [])
    |> Enum.map(& Repo.get(SportDiscipline, &1))
  end

  def are_disciplines_available?(%SportArena{} = arena, desired_disciplines_ids) when is_list(desired_disciplines_ids) do
    arena_disciplines =
      Repo.preload(arena, :sport_disciplines)
      |> Map.get(:sport_disciplines)
      |> Enum.map(fn %SportDiscipline{id: id} -> id end)

    Enum.count(desired_disciplines_ids -- arena_disciplines) == 0
  end

  def calculate_num_of_time_windows(%SportArena{} = arena, %Date{} = day) do
    Repo.preload(arena, :events)
    |> Map.get(:events)
    |> Enum.filter(fn event -> Date.compare(event.event_day, day) == :eq end)
    |> Enum.map(fn event -> {event.start_time, event.end_time} end)
    |> calculate_time_windows()
    |> Enum.reduce(0, fn val, acc -> if val > 1.0, do: acc + 1, else: acc end)
  end

  defp calculate_time_windows([]) do
    [Hadrian.Time.diff_in_hours(@close_time, @open_time)]
  end

  defp calculate_time_windows([only_event]) do
    first_window = calculate_first_time_window(only_event)
    second_window = calculate_last_time_window(only_event)

    [first_window, second_window]
  end

  defp calculate_time_windows([first_event, second_event]) do
    first_window = calculate_first_time_window(first_event)
    second_window = calculate_time_window([first_event, second_event])
    third_window = calculate_last_time_window(second_event)

    [first_window, second_window, third_window]
  end

  defp calculate_time_windows(events) when is_list(events) do
    first = List.first(events)
    last = List.last(events)

    time_windows =
      []
      |> Enum.concat([calculate_first_time_window(first)])
      |> Enum.concat([calculate_last_time_window(last)])

    events -- [first, last]
    |> Enum.flat_map(fn event -> [event, event] end)
    |> (fn doubles -> [first] ++ doubles ++ [last] end).()
    |> Enum.chunk_every(2)
    |> Enum.map(fn events_times -> calculate_time_window(events_times) end)
    |> Enum.concat(time_windows)
  end

  defp calculate_time_window([first_event_times, second_event_times]) do
    {start_time_1, end_time_1} = first_event_times
    {start_time_2, end_time_2} = second_event_times

    if Time.compare(start_time_1, start_time_2) == :gt do
      # Hadrian.Owners.SportAren.calculate_last_time_window(second_event_times, first_event_times)
      Hadrian.Time.diff_in_hours(end_time_2, start_time_1)
    else
      Hadrian.Time.diff_in_hours(end_time_1, start_time_2)
    end
  end

  defp calculate_first_time_window({start_time, _}) do
    Hadrian.Time.diff_in_hours(@open_time, start_time)
  end

  defp calculate_last_time_window({_, end_time}) do
    Hadrian.Time.diff_in_hours(@close_time, end_time)
  end
end