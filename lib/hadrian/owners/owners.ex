defmodule Hadrian.Owners do
  @moduledoc """
  The Owners context.
  """

  import Ecto.Query, warn: false
  alias Hadrian.Repo

  alias Hadrian.Owners.SportComplex

  @doc """
  Returns the list of sport_complexes.

  ## Examples

      iex> list_sport_complexes()
      [%SportComplex{}, ...]

  """
  def list_sport_complexes do
    Repo.all(SportComplex)
  end

  @doc """
  Gets a single sport_complex.

  Raises `Ecto.NoResultsError` if the Sport complex does not exist.

  ## Examples

      iex> get_sport_complex!(123)
      %SportComplex{}

      iex> get_sport_complex!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sport_complex!(id), do: Repo.get!(SportComplex, id)

  @doc """
  Creates a sport_complex.

  ## Examples

      iex> create_sport_complex(%{field: value})
      {:ok, %SportComplex{}}

      iex> create_sport_complex(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sport_complex(attrs \\ %{}) do
    %SportComplex{}
    |> SportComplex.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sport_complex.

  ## Examples

      iex> update_sport_complex(sport_complex, %{field: new_value})
      {:ok, %SportComplex{}}

      iex> update_sport_complex(sport_complex, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sport_complex(%SportComplex{} = sport_complex, attrs) do
    sport_complex
    |> SportComplex.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SportComplex.

  ## Examples

      iex> delete_sport_complex(sport_complex)
      {:ok, %SportComplex{}}

      iex> delete_sport_complex(sport_complex)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sport_complex(%SportComplex{} = sport_complex) do
    Repo.delete(sport_complex)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sport_complex changes.

  ## Examples

      iex> change_sport_complex(sport_complex)
      %Ecto.Changeset{source: %SportComplex{}}

  """
  def change_sport_complex(%SportComplex{} = sport_complex) do
    SportComplex.changeset(sport_complex, %{})
  end

  alias Hadrian.Owners.SportObject

  @doc """
  Returns the list of sport_objects.

  ## Examples

      iex> list_sport_objects()
      [%SportObject{}, ...]

  """
  def list_sport_objects do
    Repo.all(SportObject)
  end

  @doc """
  Gets a single sport_object.

  Raises `Ecto.NoResultsError` if the Sport object does not exist.

  ## Examples

      iex> get_sport_object!(123)
      %SportObject{}

      iex> get_sport_object!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sport_object!(id), do: Repo.get!(SportObject, id)

  @doc """
  Creates a sport_object.

  ## Examples

      iex> create_sport_object(%{field: value})
      {:ok, %SportObject{}}

      iex> create_sport_object(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sport_object(attrs \\ %{}) do
    %SportObject{}
    |> SportObject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sport_object.

  ## Examples

      iex> update_sport_object(sport_object, %{field: new_value})
      {:ok, %SportObject{}}

      iex> update_sport_object(sport_object, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sport_object(%SportObject{} = sport_object, attrs) do
    sport_object
    |> SportObject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SportObject.

  ## Examples

      iex> delete_sport_object(sport_object)
      {:ok, %SportObject{}}

      iex> delete_sport_object(sport_object)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sport_object(%SportObject{} = sport_object) do
    Repo.delete(sport_object)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sport_object changes.

  ## Examples

      iex> change_sport_object(sport_object)
      %Ecto.Changeset{source: %SportObject{}}

  """
  def change_sport_object(%SportObject{} = sport_object) do
    SportObject.changeset(sport_object, %{})
  end

  alias Hadrian.Owners.DailySchedule

  @doc """
  Returns the list of daily_schedules.

  ## Examples

      iex> list_daily_schedules()
      [%DailySchedule{}, ...]

  """
  def list_daily_schedules do
    Repo.all(DailySchedule)
  end

  @doc """
  Gets a single daily_schedule.

  Raises `Ecto.NoResultsError` if the Daily schedule does not exist.

  ## Examples

      iex> get_daily_schedule!(123)
      %DailySchedule{}

      iex> get_daily_schedule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_daily_schedule!(id), do: Repo.get!(DailySchedule, id)

  @doc """
  Creates a daily_schedule.

  ## Examples

      iex> create_daily_schedule(%{field: value})
      {:ok, %DailySchedule{}}

      iex> create_daily_schedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_daily_schedule(attrs \\ %{}) do
    %DailySchedule{}
    |> DailySchedule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a daily_schedule.

  ## Examples

      iex> update_daily_schedule(daily_schedule, %{field: new_value})
      {:ok, %DailySchedule{}}

      iex> update_daily_schedule(daily_schedule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_daily_schedule(%DailySchedule{} = daily_schedule, attrs) do
    daily_schedule
    |> DailySchedule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a DailySchedule.

  ## Examples

      iex> delete_daily_schedule(daily_schedule)
      {:ok, %DailySchedule{}}

      iex> delete_daily_schedule(daily_schedule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_daily_schedule(%DailySchedule{} = daily_schedule) do
    Repo.delete(daily_schedule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking daily_schedule changes.

  ## Examples

      iex> change_daily_schedule(daily_schedule)
      %Ecto.Changeset{source: %DailySchedule{}}

  """
  def change_daily_schedule(%DailySchedule{} = daily_schedule) do
    DailySchedule.changeset(daily_schedule, %{})
  end

  alias Hadrian.Owners.TimeBlock

  @doc """
  Returns the list of time_blocks.

  ## Examples

      iex> list_time_blocks()
      [%TimeBlock{}, ...]

  """
  def list_time_blocks do
    Repo.all(TimeBlock)
  end

  @doc """
  Gets a single time_block.

  Raises `Ecto.NoResultsError` if the Time block does not exist.

  ## Examples

      iex> get_time_block!(123)
      %TimeBlock{}

      iex> get_time_block!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_block!(id), do: Repo.get!(TimeBlock, id)

  @doc """
  Creates a time_block.

  ## Examples

      iex> create_time_block(%{field: value})
      {:ok, %TimeBlock{}}

      iex> create_time_block(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_block(attrs \\ %{}) do
    %TimeBlock{}
    |> TimeBlock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a time_block.

  ## Examples

      iex> update_time_block(time_block, %{field: new_value})
      {:ok, %TimeBlock{}}

      iex> update_time_block(time_block, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_block(%TimeBlock{} = time_block, attrs) do
    time_block
    |> TimeBlock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TimeBlock.

  ## Examples

      iex> delete_time_block(time_block)
      {:ok, %TimeBlock{}}

      iex> delete_time_block(time_block)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_block(%TimeBlock{} = time_block) do
    Repo.delete(time_block)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_block changes.

  ## Examples

      iex> change_time_block(time_block)
      %Ecto.Changeset{source: %TimeBlock{}}

  """
  def change_time_block(%TimeBlock{} = time_block) do
    TimeBlock.changeset(time_block, %{})
  end
end
