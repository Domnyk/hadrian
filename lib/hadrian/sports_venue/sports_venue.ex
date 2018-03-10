defmodule Hadrian.SportsVenue do
  @moduledoc """
  The SportsVenue context.
  """

  import Ecto.Query, warn: false
  alias Hadrian.Repo

  alias Hadrian.SportsVenue.SportsDiscipline

  @doc """
  Returns the list of sports_disciplines.

  ## Examples

      iex> list_sports_disciplines()
      [%SportsDiscipline{}, ...]

  """
  def list_sports_disciplines do
    Repo.all(SportsDiscipline)
  end

  @doc """
  Gets a single sports_discipline.

  Raises `Ecto.NoResultsError` if the Sports discipline does not exist.

  ## Examples

      iex> get_sports_discipline!(123)
      %SportsDiscipline{}

      iex> get_sports_discipline!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sports_discipline!(id), do: Repo.get!(SportsDiscipline, id)

  @doc """
  Creates a sports_discipline.

  ## Examples

      iex> create_sports_discipline(%{field: value})
      {:ok, %SportsDiscipline{}}

      iex> create_sports_discipline(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sports_discipline(attrs \\ %{}) do
    %SportsDiscipline{}
    |> SportsDiscipline.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sports_discipline.

  ## Examples

      iex> update_sports_discipline(sports_discipline, %{field: new_value})
      {:ok, %SportsDiscipline{}}

      iex> update_sports_discipline(sports_discipline, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sports_discipline(%SportsDiscipline{} = sports_discipline, attrs) do
    sports_discipline
    |> SportsDiscipline.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SportsDiscipline.

  ## Examples

      iex> delete_sports_discipline(sports_discipline)
      {:ok, %SportsDiscipline{}}

      iex> delete_sports_discipline(sports_discipline)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sports_discipline(%SportsDiscipline{} = sports_discipline) do
    Repo.delete(sports_discipline)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sports_discipline changes.

  ## Examples

      iex> change_sports_discipline(sports_discipline)
      %Ecto.Changeset{source: %SportsDiscipline{}}

  """
  def change_sports_discipline(%SportsDiscipline{} = sports_discipline) do
    SportsDiscipline.changeset(sports_discipline, %{})
  end
end
