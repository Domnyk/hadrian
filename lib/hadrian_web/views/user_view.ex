defmodule HadrianWeb.Api.UserView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end
  
  def render("ok.create.json", %{user: user}) do
    %{status: :ok,
      id: user.id,
      email: user.email,
      login: user.login,
      display_name: user.display_name}
  end

  def render("error.create.json", %{errors: errors}) do
    Enum.reduce(errors, %{}, &put_error_into_acc/2)
    |> Map.put(:status, :error)
  end

  defp put_error_into_acc(error, acc) do
    field = elem(error, 0)
    extra_info = elem(error, 1)
    reason = elem(extra_info, 0)

    Map.put(acc, field, reason)
  end
end