defmodule Hadrian.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Hadrian.Repo
  alias Hadrian.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do 
    Repo.get!(User, id)
  end

  def get_user_by_paypal_email(email) when is_binary(email) do
    case Repo.get_by(User, paypal_email: email) do
      %User{} = user -> {:ok, user}
      _ -> {:no_such_user, paypal_email: email}
    end
  end

  def get_user_by_fb_id(fb_id) when is_binary(fb_id) do
    case Repo.get_by(User, fb_id: fb_id) do
      %User{} = user -> {:ok, user}
      _ -> {:no_such_user, fb_id: fb_id}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  # defp insert_password_hash(%Changeset{} = changeset) do
  #   password_hash = Comeonin.Bcrypt.hashpwsalt(changeset.changes.password)
  #
  #   Changeset.change(changeset, password_hash: password_hash)
  # end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Hadrian.Accounts.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end


  alias Hadrian.Accounts.ComplexesOwner

  @doc """
  Returns the list of complexes owners.

  ## Examples

      iex> list_complexes_owners()
      [%ComplexesOwner{}, ...]

  """
  def list_complexes_owners do
    Repo.all(ComplexesOwner)
  end

  @doc """
  Gets a single complex owner.

  Raises `Ecto.NoResultsError` if the complexes owner does not exist.

  ## Examples

      iex> get_complexes_owner!(123)
      %ComplexesOwner{}

      iex> get_complexes_owner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_complexes_owner!(id), do: Repo.get!(ComplexesOwner, id)



  def get_complexes_owner_by_email(email) do
    case Repo.get_by(ComplexesOwner, email: email) do
      %ComplexesOwner{} = complexes_owner -> {:ok, complexes_owner}
      _ -> {:no_such_complexes_owner, email: email}
    end
  end

  @doc """
  Creates a complexes owner.

  ## Examples

      iex> create_complexes_owner(%{field: value})
      {:ok, %ComplexesOwner{}}

      iex> create_complexes_owner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_complexes_owner(attrs \\ %{}) do
    %ComplexesOwner{}
    |> ComplexesOwner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a complexes owner.

  ## Examples

      iex> update_complexes_owner(role, %{field: new_value})
      {:ok, %ComplexesOwner{}}

      iex> update_complexes_owner(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_complexes_owner(%ComplexesOwner{} = complexes_owner, attrs) do
    complexes_owner
    |> ComplexesOwner.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a complexes owner.

  ## Examples

      iex> delete_complexes_owner(complexes_owner)
      {:ok, %ComplexesOwner{}}

      iex> delete_complexes_owner(complexes_owner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_complexes_owner(%ComplexesOwner{} = complexes_owner) do
    Repo.delete(complexes_owner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking complexes owner changes.

  ## Examples

      iex> change_complexes_owner(ComplexesOwner)
      %Ecto.Changeset{source: %ComplexesOwner{}}

  """
  def change_complexes_owner(%ComplexesOwner{} = complexes_owner) do
    ComplexesOwner.changeset(complexes_owner, %{})
  end
end
