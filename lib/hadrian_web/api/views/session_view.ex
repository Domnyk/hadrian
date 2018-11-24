defmodule HadrianWeb.Api.SessionView do
  def render("ok.create.json", %{current_user: current_user}) do
    %{
      status: :ok
    }
  end

  def render("warning.create.json", %{message: message}) do
    %{
      status: :warning,
      message: message
    }
  end

  def render("ok.delete.json", %{}) do
    %{status: :ok}
  end

end
