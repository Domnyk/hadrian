defmodule Hadrian.Repo.Migrations.AddSportDisciplinesInSportArenas do
  use Ecto.Migration

  def up do
    create table("sport_disciplines_in_sport_arenas") do
      add :sport_discipline_id, references("sport_disciplines")
      add :sport_arena_id, references("sport_arenas"), on_delete: :deleta_all
    end

    create unique_index(:sport_disciplines_in_sport_arenas, [:sport_discipline_id, :sport_arena_id])
  end

  def down do
    drop index("sport_disciplines_in_sport_arenas", [:sport_discipline_id, :sport_arena_id])

    drop table("sport_disciplines_in_sport_arenas")
  end
end
