defmodule HadrianWeb.Router do
  use HadrianWeb, :router
 
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HadrianWeb.Api do
    pipe_through :api

    resources "/users", UserController, only: [:index, :create]
    post "/token", TokenController, :create
  end
end
