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

  scope "/auth", HadrianWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    get "/:provider/logout", AuthController, :logout
  end

  scope "/", HadrianWeb do
    pipe_through :browser # Use the default browser stack

    get "/", RootController, :index

    resources "/sports_disciplines", SportsDisciplineController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HadrianWeb do
  #   pipe_through :api
  # end
end
