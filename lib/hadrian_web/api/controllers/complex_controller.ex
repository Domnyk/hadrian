defmodule HadrianWeb.Api.ComplexController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportComplex

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, _params) do
    complexes = Owners.list_sport_complexes

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

    with {:ok, %SportComplex{} = complex} <- Owners.update_sport_complex(complex, attrs) do
      conn
      |> put_status(:ok)
      |> render("show.json", complex: complex)
    end
  end
  
  def delete(conn, %{"id" => id}) do
    with {:ok, %SportComplex{} = complex} <- Owners.get_sport_complex(id),
         {:ok, %SportComplex{}} <- Owners.delete_sport_complex(complex) do
      conn
      |> put_status(:ok)
      |> render("show.json", complex: complex)
    else
      :not_found -> send_resp(conn, :not_found, "")
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
end