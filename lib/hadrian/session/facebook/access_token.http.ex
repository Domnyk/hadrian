defmodule Hadrian.Session.Facebook.AccessToken.HTTP do
  use HTTPoison.Base

  import Logger

  @behaviour Hadrian.Session.Facebook.AccessToken

  def valid?(params) do
    fb_access_token = params["access_token"]

    if not has_correct_format?(fb_access_token) do
      false
    else
      case inspect_token_in_fb(fb_access_token) do
        {:ok, %HTTPoison.Response{body: body} = resp} ->
          Poison.decode!(body)["data"]["is_valid"]
          |> Utils.String.to_boolean!
        {:error, _} -> false
      end
    end
  end

  defp inspect_token_in_fb(fb_access_token) do
    hadrian_access_token = System.get_env("FACEBOOK_APP_ID")
    hadrian_secret = System.get_env("FACEBOOK_APP_SECRET")
    verification_url = get_verification_url(fb_access_token, hadrian_access_token, hadrian_secret)

    case get(verification_url) do
      {:ok, %HTTPoison.Response{status_code: 200} = resp} -> {:ok, resp}
      {:error, resp} -> {:error, "Error while checking access token"}
    end
  end

  defp request(atom, binary, term, headers, options) do
   Logger.debug "[HTTP(S)] [AccessToken verification URL] " <> binary
   super(atom, binary, term, headers, options) 
  end

  defp get_verification_url(fb_access_token, hadrian_access_token, hadrian_secret) do
    "https://graph.facebook.com/debug_token?input_token=" <> 
    fb_access_token <> 
    "&access_token=" <> 
    hadrian_access_token <> "|" <> hadrian_secret
  end

  defp process_response_body(body) do
    Logger.debug "[HTTP(S)] [Response from FB Graph API] " <> body
    body
  end

  defp has_correct_format?(token) do
    if is_nil(token) or String.length(token) == 0 do
      false
    else
      true
    end
  end
end
