defmodule HadrianWeb.Api.SportComplexView do
  use HadrianWeb, :view
  
  alias HadrianWeb.Api.SportComplexView

  def render("index.json", %{sport_complexs: sport_complexs}) do
    %{status: :ok,
      data: render_many(sport_complexs, SportComplexView, "sport_complex.json")}
  end

  def render("sport_complex.json", %{sport_complex: sport_complex}) do
    %{id: sport_complex.id, 
      name: sport_complex.name}
  end

  def render("ok.create.json", %{sport_complex: sport_complex}) do
    %{status: :ok,
      data: render("sport_complex.json", sport_complex: sport_complex)}
  end

  def render("error.create.json", %{changeset: changeset}) do
    import Ecto.Changeset, only: [traverse_errors: 2]

    parse_errors(changeset)
    |> Map.put(:status, :error)
  end

  defp parse_errors(changeset) do
    import Ecto.Changeset, only: [traverse_errors: 2]

    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end