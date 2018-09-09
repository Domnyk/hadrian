defmodule Hadrian.Session.Facebook.AccessToken do
  @type email :: String.t()
  @type access_token :: String.t()
  @type access_token_params_map :: %{required(String.t()) => access_token, required(String.t()) => email} 
  
  @doc """
  Checks whether access token from params map is valid
  """
  @callback valid?(params :: access_token_params_map) :: boolean()
end