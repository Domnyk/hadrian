defmodule HadrianWeb.Api.SportArenaController do
  use HadrianWeb, :controller

  alias Hadrian.Owners
  alias Hadrian.Owners.SportArena

  action_fallback HadrianWeb.Api.FallbackController

  def index(conn, %{"sport_object_id" => sport_object_id}) do
    sport_arenas = Owners.list_sport_arenas(sport_object_id)
    render(conn, "index.json", sport_arenas: sport_arenas)
  end

  def create(conn, %{"data" => %{"sport_arena" => sport_arena_params}}) do
   with {:ok, %SportArena{} = sport_arena} <- Owners.create_sport_arena(sport_arena_params) do
     conn
     |> put_status(:created)
     |> render("show.json", sport_arena: sport_arena)
   end
  end
  
  #
  # def update(conn, %{"id" => id, "sport_arena" => sport_arena_params}) do
  #   sport_arena = Owners.get_sport_arena!(id)
  #
  #   with {:ok, %SportArena{} = sport_arena} <- Owners.update_sport_arena(sport_arena, sport_arena_params) do
  #     render(conn, "show.json", sport_arena: sport_arena)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   sport_arena = Owners.get_sport_arena!(id)
  #   with {:ok, %SportArena{}} <- Owners.delete_sport_arena(sport_arena) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
