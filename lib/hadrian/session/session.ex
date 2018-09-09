defmodule Hadrian.Session do
  alias Hadrian.Session.InApp
  alias Hadrian.Session.Facebook

  def login(%{"auth_method" => auth_method} = params) do
    case auth_method do
      "in_app" -> InApp.login(params["user"])
      "facebook" -> Facebook.login(params["user"])
      _ -> {:error, reason: "Unkown authorization method in params map"}
    end
  end

  def login(_) do
    {:error, reason: "No authorization method in params map"}
  end
end