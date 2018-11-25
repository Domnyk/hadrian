defmodule Hadrian.Authentication.Facebook do
  require Logger

  def exchange_code_for_access_token(code, redirect_endpoint) do
    exchange_url = generate_exchange_url(System.get_env("FACEBOOK_APP_ID"), redirect_endpoint,
                                         System.get_env("FACEBOOK_APP_SECRET"), code)


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

  def get_user_email(access_token) do
    user_email_endpoint = get_user_email_endpoint(access_token)

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(user_email_endpoint),
         {:ok, user_data} <- Poison.decode(body)
      do
      {:ok, user_data["email"]}
    else
      {:error, data} -> Logger.error(inspect(data))
    end
  end

  def get_sign_in_endpoint(client_id, redirect_uri) do
    "https://www.facebook.com/v3.1/dialog/oauth?"
    <> "client_id=#{client_id}"
    <> "&redirect_uri=#{redirect_uri}"
    <> "&scope=email"
  end

  defp generate_exchange_url(client_id, redirect_uri, client_secret, code) do
    "https://graph.facebook.com/v3.1/oauth/access_token?"
    <> "client_id=#{client_id}"
    <> "&redirect_uri=#{redirect_uri}"
    <> "&client_secret=#{client_secret}"
    <> "&code=#{code}"
  end

  defp get_user_email_endpoint(access_token) do
    "https://graph.facebook.com/v3.1/me?"
    <> "fields=email"
    <> "&access_token=#{access_token}"
  end
end
