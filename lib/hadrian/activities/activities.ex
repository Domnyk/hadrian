defmodule Hadrian.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias Hadrian.Repo

  alias Hadrian.Activities.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events(sport_arena_id) when is_integer(sport_arena_id) do
    Repo.all(Event)
    |> Repo.preload(:participators)
    |> Enum.filter(fn event -> event.sport_arena_id == sport_arena_id end)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    Repo.get!(Event, id)
    |> Repo.preload(:participators)
  end

  @doc """
  Creates an event.

  Creates an event and associates events' creator with this event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias Hadrian.Activities.Participation
  alias Hadrian.Accounts.User

  def list_participations(event_id) do
    query = from p in Participation, where: p.event_id == ^event_id

    Repo.all(query)
  end

  def get_participation!(event_id, user_id) do
    Repo.get_by!(Participation, %{event_id: event_id, user_id: user_id})
  end

  def create_participation(%Event{} = event, %User{} = user, is_event_owner \\ false) do
    attrs = %{user_id: user.id, event_id: event.id, has_paid: false, is_event_owner: is_event_owner}

    %Participation{}
    |> Participation.changeset(attrs)
    |> Repo.insert()
  end

  def update_participation(%Participation{} = participation, attrs) do
    participation
    |> Participation.changeset(attrs)
    |> Repo.update()
  end

  def delete_participation(%Participation{} = participation) do
    Repo.delete(participation)
  end

  alias Hadrian.Activities.ExternalEvent

  def list_external_events(sport_arena_id) when is_integer(sport_arena_id) do
    Repo.all(ExternalEvent)
    |> Enum.filter(fn event -> event.sport_arena_id == sport_arena_id end)
  end

  def get_external_event!(id) do
    Repo.get!(ExternalEvent, id)
  end

  def create_external_event(attrs \\ %{}) do
    %ExternalEvent{}
    |> ExternalEvent.changeset(attrs)
    |> Repo.insert()
  end

  def update_external_event(%ExternalEvent{} = external_event, attrs) do
    external_event
    |> ExternalEvent.changeset(attrs)
    |> Repo.update()
  end

  def delete_external_event(%ExternalEvent{} = external_event) do
    Repo.delete(external_event)
  end

  def change_external_event(%ExternalEvent{} = external_event) do
    ExternalEvent.changeset(external_event, %{})
  end
end
