defmodule HadrianWeb.Api.ValidationController do
  use HadrianWeb, :controller

  def validate_complex(conn, %{"name" => _} = attrs) do
    alias Hadrian.Owners.SportComplex

    case SportComplex.name_unique?(attrs) do
      true -> render(conn, "valid.json")
      false -> render(conn, "invalid.json")
    end
  end

end
