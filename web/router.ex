defmodule MediaSample.Router do
  use MediaSample.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MediaSample.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  # this scope is required. without this, root url ("/") won't be recognized. 
  scope "/", MediaSample do
    pipe_through [:browser]
    get "/", DummyController, :dummy
  end

  # ueberauth doesn't support "/:identifier" in request path. 
  # so login/logout/callback path must be defined outside of "/:locale" scope.
  scope "/admin", MediaSample.Admin, as: :admin do
    pipe_through [:browser]
    get "/auth/identity", SessionController, :new
    post "/auth/identity/callback", SessionController, :callback
    delete "/logout", SessionController, :delete
  end
  scope "/", MediaSample do
    pipe_through [:browser]
    get "/auth/:identity", SessionController, :new
    get "/auth/:identity/callback", SessionController, :callback
    post "/auth/:identity/callback", SessionController, :callback
    delete "/logout", SessionController, :delete
  end

  scope "/:locale" do
    scope "/admin", MediaSample.Admin, as: :admin do
      pipe_through [:browser]
      get "/", PageController, :index
      resources "/admin_users", AdminUserController
      resources "/users", UserController
      resources "/categories", CategoryController
      resources "/entries", EntryController
      resources "/tags", TagController
    end
    scope "/", MediaSample do
      pipe_through [:browser]
      get "/", PageController, :index
      resources "/entries", EntryController, only: [:index, :show]
    end
  end

  scope "/:locale" do
    pipe_through [:api, :api_auth]
    forward "/api", MediaSample.API
  end
end
