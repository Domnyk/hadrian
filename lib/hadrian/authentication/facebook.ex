defmodule Hadrian.Authentication.Facebook do
  require Logger

  def exchange_code_for_access_token(code) do
    exchange_url = generate_exchange_url(System.get_env("FACEBOOK_APP_ID"), System.get_env("FACEBOOK_APP_SECRET"), code)

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(exchange_url),
         {:ok, response} <- Poison.decode(body)
      do
      case Map.has_key?(response, "access_token") do
        true -> {:ok, response["access_token"]}
        false ->
          Logger.warn("No access token in received response")
          {:error, "No access token in received response"}
      end
    else
      {:error, error_data} -> Logger.error("Error when exchanging code for access token" <> inspect(error_data))
    end
  end

  def get_user(access_token) do
    user_endpoint = get_user_endpoint(access_token)

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(user_endpoint),
         {:ok, user} <- Poison.decode(body) do
      Logger.info("Received response with status 200. User data: " <> inspect(user))
      {:ok, %{fb_id: user["id"], name: user["name"]}}
    else
      {:error, data} -> Logger.error(inspect(data))
    end
  end

  def get_sign_in_endpoint(client_id, redirect_uri) do
    Agent.start_link(fn -> redirect_uri end, name: __MODULE__)

    "https://www.facebook.com/v3.1/dialog/oauth?"
    <> "client_id=#{client_id}"
    <> "&redirect_uri=#{redirect_uri}"
    <> "&scope=email"
  end

  defp generate_exchange_url(client_id, client_secret, code) do
    redirect_uri = Agent.get(__MODULE__, fn state -> state end)

    "https://graph.facebook.com/v3.1/oauth/access_token?"
    <> "client_id=#{client_id}"
    <> "&redirect_uri=#{redirect_uri}"
    <> "&client_secret=#{client_secret}"
    <> "&code=#{code}"
  end

  defp get_user_endpoint(access_token) do
    "https://graph.facebook.com/v3.1/me?"
    <> "fields=email,name"
    <> "&access_token=#{access_token}"
  end
end
