defmodule HadrianWeb.Router do
  use HadrianWeb, :router

  alias HadrianWeb.Api.Plugs.Authorize

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", HadrianWeb.Api do
    pipe_through :api

    resources "/sport_complexes", SportComplexController, only: [:index, :create, :update, :delete] do
      resources "/sport_objects", SportObjectController, only: [:index, :create] 
    end

    resources "/sport_objects", SportObjectController, only: [:index, :show, :update, :delete] do
      resources "/sport_arenas", SportArenaController, only: [:index, :create]
    end

    resources "/sport_arenas", SportArenaController, only: [:update, :delete]

    resources "/sport_disciplines", SportDisciplineController, only: [:index] 
    
    resources "/users", UserController, only: [:index, :create]

    resources "/session", SessionController, only: [:new, :create]
    get "/session", SessionController, :create
    delete "/session", SessionController, :delete

    resources "/sport_arenas", SportArenaController do
      resources "/events", EventController, only: [:index, :show]
    end
  end

  scope "/api", HadrianWeb.Api do
    pipe_through [:api, Authorize]

    resources "/sport_arenas", SportArenaController do
      resources "/events", EventController, only: [:create, :update, :delete]
    end
  end
end
