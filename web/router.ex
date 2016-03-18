defmodule ForEctoUpgrade.Router do
  use ForEctoUpgrade.Web, :router

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

  scope "/admin", ForEctoUpgrade.Admin, as: :admin do
    pipe_through [:browser]

    get "/login", SessionController, :new
    post "/auth/identity/callback", SessionController, :callback
    delete "/logout", SessionController, :delete

    get "/", PageController, :index

    resources "/admin_users", AdminUserController
    resources "/categories", CategoryController
  end

  scope "/", ForEctoUpgrade do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ForEctoUpgrade do
  #   pipe_through :api
  # end
end
