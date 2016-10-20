defmodule RaliGuardian.UserController do
  use RaliGuardian.Web, :controller

  alias RaliGuardian.Repo
  alias RaliGuardian.User
  alias RaliGuardian.Authorization

  def new(conn, params) do
    render conn, "new.html", current_user: Guardian.Plug.current_resource(conn)
  end
end
