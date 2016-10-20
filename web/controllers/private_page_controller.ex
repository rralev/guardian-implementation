defmodule RaliGuardian.PrivatePageController do
  use RaliGuardian.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params) do
    current_token = Guardian.Plug.current_token(conn)
    current_resource = Guardian.Plug.current_resource(conn)
    IO.puts "TOKEN:"
    IO.inspect current_token
    IO.puts "RESOURCE:"
    IO.inspect current_resource
    conn
    |> assign(:token, current_token)
    |> assign(:resourcee, current_resource)
    |> render("index.html")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: "/")
  end
end
