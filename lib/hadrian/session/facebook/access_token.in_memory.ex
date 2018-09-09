defmodule Hadrian.Session.Facebook.AccessToken.InMemory do
  @behaviour Hadrian.Session.Facebook.AccessToken
  
  def valid?(params) do
    fb_access_token = params["access_token"]

    if not has_correct_format?(fb_access_token) do
      false
    else
      true
    end
  end

  defp has_correct_format?(token) do
    if is_nil(token) or String.length(token) == 0 do
      false
    else
      true
    end
  end
end