defmodule HadrianWeb.Router do
  use HadrianWeb, :router

  alias HadrianWeb.Api.Plugs.Authorize

  pipeline :api_with_logger do
    plug Plug.Logger
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_without_logger do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :authorize_client do
    plug HadrianWeb.Api.Plugs.AuthorizeClient
  end

  scope "/api", HadrianWeb.Api do
    pipe_through :api_without_logger
    get "/status", StatusController, :index
  end

  scope "/api", HadrianWeb.Api do
    pipe_through :api_with_logger

    scope "/validate" do
      post "/complex", ValidationController, :validate_complex
    end

    resources "/complexes", ComplexController, only: [:index] do
      resources "/sport_objects", SportObjectController, only: [:index]
    end

    post "/sport_objects/search", SportObjectController, :search
    resources "/sport_objects", SportObjectController, only: [:index, :show] do
      resources "/sport_arenas", SportArenaController, only: [:index]
    end

    resources "/sport_disciplines", SportDisciplineController, only: [:index] 
    
    resources "/users", UserController, only: [:index, :create]

    resources "/session", SessionController, only: [:new, :create]
    get "/session", SessionController, :create

    resources "/sport_arenas", SportArenaController, only: [] do
      resources "/events", EventController, only: [:index, :show]
      resources "/external_events", ExternalEventController, only: [:index]
    end

    resources "/external_events", ExternalEventController, only: [:show]

    scope "/" do
      pipe_through [Authorize]

      post "/objects/search", SportObjectController, :search

      scope "/" do
        pipe_through [HadrianWeb.Api.Plugs.AuthorizeOwner]

        resources "/complexes", ComplexController, only: [:create, :update, :delete] do
          resources "/sport_objects", SportObjectController, only: [:create]
        end

        resources "/sport_objects", SportObjectController, only: [:update, :delete] do
          resources "/sport_arenas", SportArenaController, only: [:create]
        end

        resources "/sport_arenas", SportArenaController, only: [:update, :delete] do
          resources "/external_events", ExternalEventController, only: [:create]
        end

        resources "/external_events", ExternalEventController, only: [:update, :delete]
      end

      delete "/session", SessionController, :delete

      patch "/users/:id", UserController, :update

      resources "/sport_arenas", SportArenaController do
        pipe_through :authorize_client

        resources "/events", EventController, only: [:create, :update, :delete]
      end

      resources "/events", EventController do
        resources "/participators", ParticipationController, only: [:index, :create]
        delete "/participators", ParticipationController, :delete
        get "/payments/approve", PaymentController, :approve
        get "/payments/execute", PaymentController, :execute
      end
    end
  end
end
