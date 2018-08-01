defmodule HadrianWeb.Router do
  use HadrianWeb, :router

  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth/:provider", HadrianWeb do
    pipe_through :browser

    get "/", AuthController, :login
    get "/callback", AuthController, :login_callback
    delete "/", AuthController, :logout
  end

  scope "/", HadrianWeb do
    pipe_through :browser # Use the default browser stack

    get "/", RootController, :index

    resources "/sport_complexes", SportComplexController
    resources "/sport_objects", SportObjectController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HadrianWeb do
  #   pipe_through :api
  # end
end
