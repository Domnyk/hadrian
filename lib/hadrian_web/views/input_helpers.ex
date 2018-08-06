defmodule HadrianWeb.InputHelpers do
  use Phoenix.HTML

  import Phoenix.HTML.Tag

  def interval_input(form, field, opts \\ []) do
    months_input = interval_input_for_time_spec(form, field, :months)
    days_input = interval_input_for_time_spec(form, field, :days)
    secs_input = interval_input_for_time_spec(form, field, :secs)

    [months_input, days_input, secs_input]
  end

  defp interval_input_for_time_spec(form, field, time_spec) do
    label_field_name = Atom.to_string(field) <> " in " <> Atom.to_string(time_spec)

    input_name = form.id <> "[" <> Atom.to_string(field) <> "][" <> Atom.to_string(time_spec) <> "]"
    input_value = Map.get(form.data, field)
    |> Map.get(time_spec)

    wrapper_opts = [class: "form-group"]
    label_opts = [class: "control-label"]
    input_opts = [class: "form-control", name: input_name, value: input_value ]

    content_tag :div, wrapper_opts do
      label = label(form, label_field_name, humanize(label_field_name), label_opts)
      input = apply(Phoenix.HTML.Form, :text_input, [form, field, input_opts])
      error = HadrianWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end
end