defmodule Hadrian.Payments.Token do
  require Logger

  alias HTTPoison, as: HTTP

  @token_endpoint "/v1/oauth2/token"
  @grant_type "client_credentials"

  def fetch(client_id, secret) when is_binary(client_id) and is_binary(secret) do
    Logger.info("Attempt to fetch payments token")

    url = Application.get_env(:hadrian, :api_url) <> @token_endpoint
    body = create_body(@grant_type)
    headers = create_headers()
    options = create_options(client_id, secret)
    with {:ok, response = %HTTP.Response{}} <- HTTP.post(url, body, headers, options),
         {:ok, %HTTP.Response{body: body}} <- parse_status_code(response),
         {:ok, token} <- parse_body(body) do
      Logger.info("Token fetched")
      token
    else
      {:error, %HTTP.Error{reason: :timeout}} -> "" # Returning empty string. Other paypal related functions will fetch token
      {:error, error = %HTTP.Error{}} -> handle_fetch_error(error)
      {:status_code_is_not_200, response = %HTTP.Response{}} -> handle_wrong_status_code(response)
      {:json_decoding_error, %{error: error, body: body}} -> handle_decoding_error(error, body)
    end
  end

  def fetch(client_id, secret) do
    msg = ~s(Wrong type of arguments. \n client_id: #{inspect(client_id)} \n secret: #{inspect(secret)})
    raise ArgumentError, message: msg
  end

  defp create_headers() do
    ["Accept": "application/json", "Accept-Language": "en_US", "Content-Type": "application/x-www-form-urlencoded"]
  end

  defp create_body(grant_type) when is_binary(grant_type) do
    ["grant_type=#{grant_type}"]
  end

  defp create_body(grant_type) do
    msg = ~s(Wrong argument. \n grant_type: #{inspect(grant_type)})
    raise ArgumentError, message: msg
  end

  defp create_options(client_id, secret) when is_binary(client_id) and is_binary(secret) do
    [hackney: [basic_auth: {client_id, secret}]]
  end

  defp create_options(client_id, secret) do
    msg = ~s(Wrong type of arguments. \n client_id: #{inspect(client_id)} \n secret: #{inspect(secret)})
    raise ArgumentError, message: msg
  end

  defp parse_body(body) when is_binary(body) do
    alias Poison, as: Json

    case Json.decode(body) do
      {:ok, %{"access_token" => access_token}} -> {:ok, access_token}
      {:error, error} -> {:json_decoding_error, %{error: error, body: body}}
    end
  end

  defp parse_body(_body) do
    Logger.error("parse_body/1: body is not string")
  end

  defp parse_status_code(response = %HTTP.Response{status_code: status_code}) do
    case status_code do
      200 -> {:ok, response}
      _ -> {:status_code_is_not_200, response}
    end
  end

  defp parse_status_code(response) do
    msg = ~s(parse_status_code/1 called with wrong argument type: \n #{inspect(response)})
    Logger.error(msg)
  end

  defp handle_wrong_status_code(response = %HTTP.Response{status_code: status_code}) do
    msg = ~s(Received response with code #{status_code}: \n #{inspect(response)})
    Logger.error(msg)
  end

  defp handle_wrong_status_code(response) do
    msg = ~s(handle_wrong_status_code/1 called with wrong argument type: \n #{inspect(response)})
    Logger.error(msg)
  end

  defp handle_fetch_error(error = %HTTP.Error{}) do
    Logger.error("Error while fetching token")
    error
    |> inspect()
    |> Logger.error()
  end

  defp handle_fetch_error(error) do
    Logger.error("handle_fetch_error/1 called with wrong type of error")
    error
    |> inspect()
    |> Logger.error()
  end

  defp handle_decoding_error(error, body) do
    msg = ~s(Error while decoding response's body \n Body: #{inspect(body)} \n Error: #{inspect(error)})
    Logger.error(msg)
  end

end
