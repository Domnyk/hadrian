defmodule HadrianWeb.Router do
  use HadrianWeb, :router

  # require Ueberauth

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

  scope "/sign_up", HadrianWeb do
    pipe_through :browser

    get "/in_app", RegistrationController, :new
    post "/in_app", RegistrationController, :create
  end

  scope "/sign_in", HadrianWeb do
    pipe_through :browser

    get "/in_app", SessionController, :new
    post "/in_app", SessionController, :create

    get "/facebook", SessionController, :new
    get "/facebook/callback", SessionController, :create
  end

  scope "/", HadrianWeb do
    pipe_through :browser # Use the default browser stack

    get "/", RootController, :index

    resources "/sport_complexes", SportComplexController
    resources "/sport_objects", SportObjectController
    resources "/sport_arenas", SportArenaController
    resources "/daily_schedules", DailyScheduleController
    resources "/time_blocks", TimeBlockController
    resources "/events", EventController
    # resources "/users", UserController

    # get "/sign_in", SessionController, :new
    # post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", HadrianWeb do
  #   pipe_through :api
  # end
end
