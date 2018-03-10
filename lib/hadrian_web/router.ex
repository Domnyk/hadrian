defmodule HadrianWeb.Router do
  use HadrianWeb, :router

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

  scope "/", HadrianWeb do
    pipe_through :browser # Use the default browser stack

    resources "/sports_disciplines", SportsDisciplineController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HadrianWeb do
  #   pipe_through :api
  # end
end
