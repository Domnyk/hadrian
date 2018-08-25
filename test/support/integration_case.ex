defmodule HadrianWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use HadrianWeb.ConnCase
      use PhoenixIntegration
    end
  end
end