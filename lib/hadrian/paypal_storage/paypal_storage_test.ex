defmodule Hadrian.PaypalStorage.Test do
  use Agent

  require Logger

  def start_link() do
    Agent.start_link(fn -> %{token: "1234567890"} end, name: __MODULE__)
  end

  def get_token do
    Agent.get(__MODULE__, &Map.get(&1, :token))
  end

  def put_token(token) when is_binary(token) do
    Logger.info "Token has been replaced"
    Agent.update(__MODULE__, &Map.put(&1, :token, token))
  end

  def put_token(_token) do
    raise ArgumentError, "token is not binary"
  end

end
