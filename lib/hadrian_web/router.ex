defmodule HadrianWeb.Router do
  use HadrianWeb, :router
 
  pipeline :api do
    plug :accepts, ["json"]
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
    post "/token", TokenController, :create
    get "/token/new", TokenController, :redirect_to_fb
    get "/token/new_callback", TokenController, :handle_fb_sign_in_resp

    resources "/session", SessionController, only: [:new, :create]
    delete "/session", SessionController, :delete
  end
end
