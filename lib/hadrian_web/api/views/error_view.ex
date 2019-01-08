defmodule HadrianWeb.Api.ErrorView do
  use HadrianWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  def render("401.json", assigns) do
    message = case Map.has_key?(assigns, :message) do
      true -> assigns.message
      false -> "You have to sign in to perform this action"
    end

    %{
      status: :error,
      reason: message
    }
  end

  def template_not_found(template, _assigns) do
    %{
      status: :error,
      reason: Phoenix.Controller.status_message_from_template(template)
    }
  end

  def parse_errors(changeset) do
    import Ecto.Changeset, only: [traverse_errors: 2]

    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
