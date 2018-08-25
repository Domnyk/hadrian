defmodule HadrianWeb.RolesListHelper do
  def adjust_for_view(roles) do
    roles
    |> Enum.map(&adjust/1)
  end

  defp adjust(role) do
    [key: role.name, value: role.id]
  end
end