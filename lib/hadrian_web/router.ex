defmodule HadrianWeb.Router do
  use HadrianWeb, :router

  alias HadrianWeb.Api.Plugs.Authorize

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", HadrianWeb.Api do
    pipe_through :api

    get "/status", StatusController, :index

    resources "/complexes", ComplexController, only: [:index] do
      resources "/sport_objects", SportObjectController, only: [:index, :create] 
    end

    post "/sport_objects/search", SportObjectController, :search
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

    scope "/" do
      pipe_through [Authorize]

      post "/objects/search", SportObjectController, :search

      resources "/complexes", ComplexController, only: [:create, :update, :delete]
      patch "/users", UserController, :update

      resources "/sport_arenas", SportArenaController do
        resources "/events", EventController, only: [:create, :update, :delete]
      end

      resources "/events", EventController do
        resources "/participators", ParticipationController, only: [:index, :create]
        get "/payments/approve", PaymentController, :approve
        get "/payments/execute", PaymentController, :execute
        delete "/participators", ParticipationController, :delete
      end
    end
  end
end
