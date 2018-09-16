defmodule Utils.String do
  def to_boolean!(string) do
    case string do
      true -> true
      "true" -> true
      "false" -> false
      _ -> false
    end
  end
end