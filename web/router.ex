defmodule RaliGuardian.Router do
  use RaliGuardian.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RaliGuardian do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/", PageController, :index
    get "/private", PrivatePageController, :index

    delete "/logout", AuthController, :logout

    resources "/users", UserController
  end

  scope "/auth", RaliGuardian do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/:identity", AuthController, :login
    get "/:identity/callback", AuthController, :callback
    post "/:identity/callback", AuthController, :callback

    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RaliGuardian do
  #   pipe_through :api
  # end
end
