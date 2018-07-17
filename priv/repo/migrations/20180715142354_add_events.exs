defmodule Hadrian.Repo.Migrations.AddEvents do
  use Ecto.Migration

  def up do
    create table("events") do
      add :min_num_of_participants,   :int
      add :max_num_of_participants,   :int
      add :duration_of_joining_phase, :interval
      add :duration_of_paying_phase,  :interval
      add :time_block_id,             references("time_blocks")
      
      timestamps()
    end

    create constraint("events", :min_num_of_participants_bigger_than_0, check: "min_num_of_participants > 0")
    create constraint("events", :max_num_of_participants_bigger_or_equal_than_min_num_of_participants,
                      check: "max_num_of_participants >= min_num_of_participants")
  end

  def down do
    drop constraint("events", :max_num_of_participants_bigger_or_equal_than_min_num_of_participants)
    drop constraint("events", :min_num_of_participants_bigger_than_0)

    drop table("events")
  end
end
