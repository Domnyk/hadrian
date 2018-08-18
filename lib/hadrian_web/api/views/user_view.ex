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
end