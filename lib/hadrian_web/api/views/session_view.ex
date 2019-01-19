defmodule HadrianWeb.Api.SessionView do
  def render("ok.create.json", %{complexes_owner: complexes_owner}) do
    %{id: complexes_owner.id,
      email: complexes_owner.email,
      paypal_email: complexes_owner.paypal_email}
  end

  def render("warning.create.json", %{message: message}) do
    %{
      status: :warning,
      message: message
    }
  end

  def render("invalid-credentials.json", %{}) do
    %{credentials: "invalid"}
  end

  def render("ok.delete.json", %{}) do
    %{status: :ok}
  end
end
