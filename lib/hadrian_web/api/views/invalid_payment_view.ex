defmodule HadrianWeb.Api.InvalidPaymentView do
  @moduledoc false
  use HadrianWeb, :view

  def render("payment_in_join_phase.json", _assigns) do
    %{status: :error, reason: "attempt to execute payment outside of payment phase"}
  end
end
