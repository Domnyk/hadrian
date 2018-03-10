defmodule Hadrian.SportsVenue.SportsDiscipline do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sports_disciplines" do
    field :min_num_of_people, :integer
    field :name, :string
    field :required_equipment, :string

    timestamps()
  end

  @doc false
  def changeset(sports_discipline, attrs) do
    sports_discipline
    |> cast(attrs, [:name, :min_num_of_people, :required_equipment])
    |> validate_required([:name, :min_num_of_people, :required_equipment])
  end
end
