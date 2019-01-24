defmodule HadrianWeb.Api.ComplexController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex
  alias HadrianWeb.Api.Helpers.Session

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, _params) do
    owner_id = Session.get_user_id(conn)
    complexes = Owners.list_sport_complexes(owner_id)

    render(conn, "index.json", complexes: complexes)
  end

  def create(conn, attrs) do
    attrs = insert_owner_in_attrs(attrs, conn)

    with {:ok, %SportComplex{} = complex} <- Owners.create_sport_complex(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", complex: complex)
    end
  end

  def update(conn, %{"id" => id} = attrs) do
    complex = Owners.get_sport_complex!(id)
    attrs = insert_owner_in_attrs(attrs, conn)

    with {:ok, :match} <- authorize_owner(conn, id),
         {:ok, %SportComplex{} = complex} <- Owners.update_sport_complex(complex, attrs) do
      conn
      |> put_status(:ok)
      |> render("show.json", complex: complex)
    end
  end
  
  def delete(conn, %{"id" => id}) do
    with {:ok, %SportComplex{} = complex} <- Owners.get_sport_complex(id),
         {:ok, :match} <- authorize_owner(conn, id),
         {:ok, %SportComplex{}} <- Owners.delete_sport_complex(complex) do
      conn
      |> put_status(:ok)
      |> render("show.json", complex: complex)
    end
  end

  defp get_owner_id(conn) do
    conn
    |> fetch_session()
    |> get_session(:current_user_id)
  end

  defp insert_owner_in_attrs(attrs, conn) when is_map(attrs) do
    Map.merge(attrs, %{"complexes_owner_id" => get_owner_id(conn)})
  end

  defp authorize_owner(conn, complex_id) do
    %SportComplex{complexes_owner_id: owner_id} = Owners.get_sport_complex!(complex_id)
    owner_id_from_session = Session.get_user_id(conn)

    case owner_id == owner_id_from_session do
      true -> {:ok, :match}
      false -> {:error, :owner_mismatch}
    end
  end
end