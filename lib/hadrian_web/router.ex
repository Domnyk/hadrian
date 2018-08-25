defmodule HadrianWeb.Router do
  use HadrianWeb, :router
 
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HadrianWeb do
    pipe_through :api

    get "/users", Api.UserController, :index
    post "/users", Api.UserController, :create
  end
end
