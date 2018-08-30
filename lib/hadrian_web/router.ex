defmodule HadrianWeb.Router do
  use HadrianWeb, :router
 
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HadrianWeb do
    pipe_through :api

    resources "/users", Api.UserController, only: [:index, :create]
    resources "/sessions", Api.SessionController, only: [:create]
  end
end
