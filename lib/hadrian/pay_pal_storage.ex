defmodule Hadrian.PayPalStorage do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{token: ""} end, name: __MODULE__)
  end

  def get_token do
    Agent.get(__MODULE__, &Map.get(&1, :token))
  end

  def put_token(token) when is_binary(token) do
    Agent.update(__MODULE__, &Map.put(&1, :token, token))
  end

  def put_token(_token) do
    raise ArgumentError, "token is not binary"
  end

end
