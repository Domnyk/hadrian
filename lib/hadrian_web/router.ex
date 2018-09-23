defmodule HadrianWeb.Router do
  use HadrianWeb, :router
 
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HadrianWeb.Api do
    pipe_through :api

    resources "/sport_complexes", SportComplexController, only: [:index, :create, :delete]
    resources "/sport_objects", SportObjectController, only: [:index] 
    resources "/users", UserController, only: [:index, :create]
    post "/token", TokenController, :create
  end
end
