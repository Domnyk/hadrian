defmodule Hadrian.ComplexTest do
  use Hadrian.DataCase

  alias Hadrian.Owners.SportComplex

  describe "name_unique?/2" do
    test "returns true when complex's name is unique" do
      attrs = %{"name" => "Unique name"}

      assert SportComplex.name_unique?(attrs)
    end

    test "returns false when complex's name is not unique" do
      name = "Non unique name"
      insert(:sport_complex, name: name)
      attrs = %{"name" => name}

      refute SportComplex.name_unique?(attrs)
    end
  end

end
