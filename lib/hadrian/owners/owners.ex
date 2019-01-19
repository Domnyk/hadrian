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

  def get_sport_complex(id) do
    try do
      {:ok, Repo.get!(SportComplex, id)}
    rescue
      Ecto.NoResultsError -> {:error, :not_found}
    end
  end

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
  Deletes a SportComplex by %SportComplex{} struct.

  ## Examples

      iex> delete_sport_complex(sport_complex)
      {:ok, %SportComplex{}}

      iex> delete_sport_complex(sport_complex)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sport_complex(%SportComplex{} = sport_complex) do
    sport_complex
    |> change_sport_complex()
    |> Ecto.Changeset.no_assoc_constraint(:sport_objects)
    |> Repo.delete()
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
  Returns the list of objects with arenas.

  ## Examples

      iex> list_sport_objects(:with_arenas)
      [%SportObject{}, ...]

  """
  def list_sport_objects(:with_arenas) do
    Repo.all(SportObject)
    |> Enum.map(&Repo.preload(&1, sport_arenas: [:sport_disciplines]))
  end

  @doc """
  Returns sport objects in sport complex

  ## Examples

      iex> list_sport_objects(1)
      [%SportObject{}, ...]

      iex> list_sport_objects(-1)
      []
  """
  def list_sport_objects(sport_complex_id) do
    with %SportComplex{} = sport_complex <- Repo.get(SportComplex, sport_complex_id) do
      sport_complex
      |> Repo.preload(:sport_objects)
      |> Map.get(:sport_objects)
    else
      nil -> []
    end
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
  Gets a single sport object with loaded sport arenas and disciplines

  Raises `Ecto.NoResultsError` if the Sport object does not exist.

  ## Examples

      iex> get_sport_object!(123)
      %SportObject{}

      iex> get_sport_object!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sport_object!(id, :with_sport_arenas_and_disciplines) do
    Repo.get!(SportObject, id)
    |> Repo.preload(sport_arenas: [:sport_disciplines])
  end

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
    sport_object
    |> Ecto.Changeset.change()
    |> Repo.delete()
  end

  @doc """
  Deletes a SportObject by id.

  ## Examples

      iex> delete_sport_object(1)
      {:ok, %SportComplex{}}

      iex> delete_sport_object(2)
      {:error, %Ecto.Changeset{}}

      iex> delete_sport_object(-1)
      {:error, :not_found}

  """
  def delete_sport_object(id) do
    with %SportObject{} = sport_object <- Repo.get(SportObject, id) do
      change_sport_object(sport_object)
      |> Repo.delete()
    else
      nil -> {:error, :not_found}
    end
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

  def search_for_objects(criteria) when is_map(criteria) do
    %{day: day, geo_location: geo_location, disciplines: disciplines} = criteria

    object_to_search_results = fn (%SportObject{} = object) ->
      %Types.GeoCoordinates{latitude: lat, longitude: lng} = object.geo_coordinates

      %{object_id: object.id,
      lowest_price: SportObject.get_lowest_price(object, disciplines),
      distance: Hadrian.Geo.distance({lat, lng}, geo_location, :km)}
    end

    Repo.all(SportObject)
    |> Repo.preload(:sport_arenas)
    |> Enum.filter(fn object -> SportObject.are_disciplines_available?(object, disciplines) end)
    |> Enum.filter(fn object -> SportObject.is_day_available?(object, day) end)
    |> Enum.map(object_to_search_results)
  end

  alias Hadrian.Owners.SportArena

  @doc """
  Returns the list of sport_arenas.

  ## Examples

      iex> list_sport_arenas()
      [%SportArena{}, ...]

  """
  def list_sport_arenas do
    Repo.all(SportArena)
  end

  @doc """
  Returns sport arenas in sport object with available sport disciplines

  ## Examples

      iex> list_sport_objects(1)
      [%SportObject{}, ...]

      iex> list_sport_objects(-1)
      []
  """
  def list_sport_arenas(sport_object_id, :with_sport_disciplines) do
    sport_arenas_in_sport_object = from a in SportArena,
                                        where: a.sport_object_id == ^sport_object_id,
                                        select: a

    Repo.all(sport_arenas_in_sport_object)
    |> Repo.preload(:sport_disciplines)
  end

  @doc """
  Returns sport arenas in sport object

  ## Examples

      iex> list_sport_objects(1)
      [%SportObject{}, ...]

      iex> list_sport_objects(-1)
      []
  """
  def list_sport_arenas(sport_object_id) do
    with %SportObject{} = sport_object <- Repo.get(SportObject, sport_object_id) do
      sport_object
      |> Repo.preload(:sport_arenas)
      |> Map.get(:sport_arenas)
    else
      nil -> []
    end
  end

  @doc """
  Gets a single sport_arena.

  Raises `Ecto.NoResultsError` if the Sport arena does not exist.

  ## Examples

      iex> get_sport_arena!(123)
      %SportArena{}

      iex> get_sport_arena!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sport_arena!(id), do: Repo.get!(SportArena, id)

  @doc """
  Creates a sport_arena.

  ## Examples

      iex> create_sport_arena(%{field: value})
      {:ok, %SportArena{}}

      iex> create_sport_arena(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sport_arena(attrs \\ %{}) do
    %SportArena{}
    |> SportArena.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sport_arena.

  ## Examples

      iex> update_sport_arena(sport_arena, %{field: new_value})
      {:ok, %SportArena{}}

      iex> update_sport_arena(sport_arena, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sport_arena(%SportArena{} = sport_arena, attrs) do
    sport_arena
    |> SportArena.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SportArena.

  ## Examples

      iex> delete_sport_arena(sport_arena)
      {:ok, %SportArena{}}

      iex> delete_sport_arena(sport_arena)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sport_arena(%SportArena{} = sport_arena) do
    Repo.delete(sport_arena)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sport_arena changes.

  ## Examples

      iex> change_sport_arena(sport_arena)
      %Ecto.Changeset{source: %SportArena{}}

  """
  def change_sport_arena(%SportArena{} = sport_arena) do
    SportArena.changeset(sport_arena, %{})
  end

  alias Hadrian.Owners.SportDiscipline

  @doc """
  Returns the list of sport_disciplines.

  ## Examples

      iex> list_sport_disciplines()
      [%SportDiscipline{}, ...]

  """
  def list_sport_disciplines do
    Repo.all(SportDiscipline)
  end

  @doc """
  Gets a single sport_discipline.

  Raises if the Sport discipline does not exist.

  ## Examples

      iex> get_sport_discipline!(123)
      %SportDiscipline{}

  """
  def get_sport_discipline!(id) do
     Repo.get!(SportDiscipline, id)
  end

  @doc """
  Creates a sport_discipline.

  ## Examples

      iex> create_sport_discipline(%{field: value})
      {:ok, %SportDiscipline{}}

      iex> create_sport_discipline(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sport_discipline(attrs \\ %{}) do
    %SportDiscipline{}
    |> SportDiscipline.changeset(attrs)
    |> Repo.insert
  end

  @doc """
  Updates a sport_discipline.

  ## Examples

      iex> update_sport_discipline(sport_discipline, %{field: new_value})
      {:ok, %SportDiscipline{}}

      iex> update_sport_discipline(sport_discipline, %{field: bad_value})
      {:error, %Ecto.Changeset}

  """
  def update_sport_discipline(%SportDiscipline{} = sport_discipline, attrs) do
    sport_discipline
    |> SportDiscipline.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SportDiscipline.

  ## Examples

      iex> delete_sport_discipline(sport_discipline)
      {:ok, %SportDiscipline{}}

      iex> delete_sport_discipline(sport_discipline)
      {:error, ...}

  """
  def delete_sport_discipline(%SportDiscipline{} = sport_discipline) do
    Repo.delete(sport_discipline)
  end

  @doc """
  Returns a datastructure for tracking sport_discipline changes.

  ## Examples

      iex> change_sport_discipline(sport_discipline)
      %Todo{...}

  """
  def change_sport_discipline(%SportDiscipline{} = sport_discipline) do
    SportDiscipline.changeset(sport_discipline, %{})
  end
end
