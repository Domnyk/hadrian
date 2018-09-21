defmodule HadrianWeb.Api.UserView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.UserView
  alias HadrianWeb.ErrorView

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

  def render("error.create.json", %{changeset: changeset}) do
    import Ecto.Changeset, only: [traverse_errors: 2]

    errors = ErrorView.parse_errors(changeset)

    %{}
    |> Map.put(:errors, errors)
    |> Map.put(:status, :error)
  end
end