defmodule HadrianWeb.Api.SessionView do
  def render("ok.create.json", %{complexes_owner: complexes_owner}) do
    %{
      status: :ok,
      email: complexes_owner.email
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
