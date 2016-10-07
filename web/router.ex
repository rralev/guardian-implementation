defmodule RaliGuardian.Router do
  use RaliGuardian.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :browser_auth do
  #   plug Guardian.Plug.VerifySession
  #   plug Guardian.Plug.LoadResource
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RaliGuardian do
    pipe_through [:browser] # Use the default browser stack

    get "/", PageController, :index
    get "/private", PrivatePageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RaliGuardian do
  #   pipe_through :api
  # end
end
