defmodule HadrianWeb.Api.UserView do
  use HadrianWeb, :view
  alias HadrianWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "show.json")}
  end

  def render("show.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      paypal_email: user.paypal_email,
      display_name: user.display_name}
  end
  
  def render("show.json", %{complexes_owner: complexes_owner}) do
    %{id: complexes_owner.id,
      email: complexes_owner.email,
      paypal_email: complexes_owner.paypal_email}
  end
end