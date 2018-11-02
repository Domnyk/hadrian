defmodule Hadrian.Repo.Migrations.DeleteSportDisciplinesWhenArenaIsDeleted do
  use Ecto.Migration

  def up do
    drop constraint "sport_disciplines_in_sport_arenas", "sport_disciplines_in_sport_arenas_sport_arena_id_fkey"

    alter table("sport_disciplines_in_sport_arenas") do
      modify(:sport_arena_id, references("sport_arenas", on_delete: :delete_all))
    end
  end

  def down do
  end
end
