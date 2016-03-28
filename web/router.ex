defmodule ForEctoUpgrade.Router do
  use ForEctoUpgrade.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ForEctoUpgrade.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # this scope is required. without this, root url ("/") won't be recognized. 
  scope "/", ForEctoUpgrade do
    pipe_through [:browser]
    get "/", DummyController, :dummy
  end

  # ueberauth doesn't support "/:identifier" in request path. 
  # so login/logout/callback path must be defined outside of "/:locale" scope.
  scope "/admin", ForEctoUpgrade.Admin, as: :admin do
    pipe_through [:browser]
    get "/auth/identity", SessionController, :new
    post "/auth/identity/callback", SessionController, :callback
    delete "/logout", SessionController, :delete
  end
  scope "/", ForEctoUpgrade do
    pipe_through [:browser]
    get "/auth/:identity", SessionController, :new
    get "/auth/:identity/callback", SessionController, :callback
    post "/auth/:identity/callback", SessionController, :callback
    delete "/logout", SessionController, :delete
  end

  scope "/:locale" do
    scope "/admin", ForEctoUpgrade.Admin, as: :admin do
      pipe_through [:browser]
      get "/", PageController, :index
      resources "/admin_users", AdminUserController
      resources "/users", UserController
      resources "/categories", CategoryController
      resources "/entries", EntryController
      resources "/tags", TagController
    end
    scope "/", ForEctoUpgrade do
      pipe_through [:browser]
      get "/", PageController, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ForEctoUpgrade do
  #   pipe_through :api
  # end
end
