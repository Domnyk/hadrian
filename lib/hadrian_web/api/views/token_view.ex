defmodule HadrianWeb.Api.TokenView do
  use HadrianWeb, :view

  def render("ok.create.json", %{token: token, current_user: current_user}) do
    email = current_user.email
    access_type = "admin"
    
    %{
      status: :ok,
      token: token,
      email: email, 
      access_type: access_type
    }
  end

  def render("error.create.json", %{reason: reason}) do
    %{
      status: :error, 
      reason: reason
    }
  end
end