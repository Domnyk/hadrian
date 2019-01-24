defmodule HadrianWeb.Api.SportArenaController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena
  alias HadrianWeb.Api.Helpers.Session

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_object_id" => sport_object_id}) do
    sport_arenas = Owners.list_sport_arenas(sport_object_id, :with_sport_disciplines)
    render(conn, "index.json", sport_arenas: sport_arenas)
  end

  def create(conn, %{"data" => %{"sport_arena" => sport_arena_params}, "sport_object_id" => sport_object_id}) do
    sport_arena_params = Map.put(sport_arena_params, "sport_object_id", sport_object_id)

    with {:ok, %SportArena{} = sport_arena} <- Owners.create_sport_arena(sport_arena_params) do
     conn
     |> put_status(:created)
     |> render("show.json", sport_arena: sport_arena)
   end
  end
  
  def update(conn, %{"data" => %{"sport_arena" => sport_arena_params}, "id" => id}) do
    with {:ok, %SportArena{} = sport_arena} <- Owners.get_sport_arena(id),
         {:ok, _} <- authorize_owner(conn, id),
         {:ok, %SportArena{} = sport_arena} <- Owners.update_sport_arena(sport_arena, sport_arena_params) do
      render(conn, "show.json", sport_arena: sport_arena)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %SportArena{} = sport_arena} <- Owners.get_sport_arena(id),
         {:ok, _} <- authorize_owner(conn, id),
         {:ok, %SportArena{}} <- Owners.delete_sport_arena(sport_arena) do
      send_resp(conn, :no_content, "")
    end
  end

  defp authorize_owner(conn, arena_id) do
    owner_id = arena_id
    |> Owners.get_sport_arena!()
    |> Map.get(:sport_object_id)
    |> Owners.get_sport_object!()
    |> Map.get(:sport_complex_id)
    |> Owners.get_sport_complex!()
    |> Map.get(:complexes_owner_id)

    owner_id_from_session = Session.get_user_id(conn)

    case owner_id == owner_id_from_session do
      true -> {:ok, :match}
      false -> {:error, :owner_mismatch}
    end
  end
end
