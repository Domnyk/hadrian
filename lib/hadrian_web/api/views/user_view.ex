defmodule HadrianWeb.Api.UserView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.UserView
  alias HadrianWeb.Api.ErrorView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end
  
  def render("ok.create.json", %{complexes_owner: complexes_owner}) do
    response = %{
      status: :ok,
      email: complexes_owner.email
    }
  end

  def render("error.create.json", %{changeset: changeset}) do
    errors = ErrorView.parse_errors(changeset)

    %{}
    |> Map.put(:errors, errors)
    |> Map.put(:status, :error)
  end
end