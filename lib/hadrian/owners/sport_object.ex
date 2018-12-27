defmodule Hadrian.Owners.SportObject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Types.TimeInterval
  alias Hadrian.Repo
  alias Hadrian.Owners.SportArena
  alias Hadrian.Owners.SportObject

  schema "sport_objects" do
    field :geo_coordinates, Types.GeoCoordinates.Ecto
    field :name, :string
    field :booking_margin, TimeInterval, default: %{months: 0, days: 0, secs: 0}
    field :address, Types.Address.Ecto

    belongs_to :sport_complex, Hadrian.Owners.SportComplex, references: :id
    has_many :sport_arenas, SportArena, foreign_key: :sport_object_id
  end

  @doc false
  def changeset(sport_object, attrs) do
    sport_object
    |> cast(attrs, [:name, :geo_coordinates, :address, :sport_complex_id, :booking_margin])
    |> validate_required([:name, :geo_coordinates, :address, :sport_complex_id, :booking_margin])
    |> foreign_key_constraint(:sport_complex_id)
    |> no_assoc_constraint(:sport_arenas)
    |> unique_constraint(:name, [name: "sport_object_name_idx"])
  end

  def get_average_price(object, desired_disciplines_ids) do
    prices =
      object
      |> Map.get(:sport_arenas)
      |> Enum.filter(fn arena -> SportArena.are_disciplines_available?(arena, desired_disciplines_ids) end)
      |> Enum.map(fn arena -> arena.price_per_hour end)

    Enum.sum(prices) / Enum.count(prices)
  end

  def are_disciplines_available?(%SportObject{} = object, desired_disciplines_ids) do
    object
    |> Map.get(:sport_arenas)
    |> Enum.map(fn arena -> SportArena.are_disciplines_available?(arena, desired_disciplines_ids) end)
    |> Enum.reduce(false, fn v, acc -> acc || v end)
  end

  def is_day_available?(%SportObject{} = object, %Date{} = day) do
    object
    |> Map.get(:sport_arenas)
    |> Enum.map(fn arena -> SportArena.calculate_num_of_time_windows(arena, day) end)
    |> Enum.reduce(false, fn v, acc -> (v > 0) || acc end)
  end
end
