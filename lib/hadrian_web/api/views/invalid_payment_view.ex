defmodule HadrianWeb.Api.InvalidPaymentView do
  @moduledoc false
  use HadrianWeb, :view
  
  def render("payment_in_join_phase.json", _assigns) do
    %{status: :error, reason: "Attempt to execute payment but event is still in join phase"}
  end
end
