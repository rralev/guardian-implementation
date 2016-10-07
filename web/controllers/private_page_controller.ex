defmodule RaliGuardian.PrivatePageController do
  use RaliGuardian.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params) do
    render conn, "index.html"
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(external: "http://elixir-lang.org/")
  end
end
