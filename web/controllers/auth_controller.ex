defmodule RaliGuardian.AuthController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use RaliGuardian.Web, :controller

  alias RaliGuardian.UserFromAuth

  plug Ueberauth

  def login(conn, params) do
    current_user = Guardian.Plug.current_resource(conn)
    current_token = Guardian.Plug.current_token(conn)
    render conn, "login.html", current_user: params["current_user"], current_auths: auths(params["current_user"])
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, current_user) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("login.html", current_user: current_user, current_auths: auths(current_user))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, params) do
    IO.puts "USERRR: "
    IO.inspect params
    case UserFromAuth.get_or_insert(auth, nil, Repo) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.name}")
        |> Guardian.Plug.sign_in(user, :access, perms: %{default: Guardian.Permissions.max})
        |> redirect(to: private_page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not authenticate. Error: #{_reason}")
        |> render("login.html", current_user: Guardian.Plug.current_resource(conn), current_auths: auths(Guardian.Plug.current_resource(conn)))
    end
  end

  def logout(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn) 
    if current_user do
      conn
      # This clears the whole session.
      # We could use sign_out(:default) to just revoke this token
      # but I prefer to clear out the session. This means that because we
      # use tokens in two locations - :default and :admin - we need to load it (see above)
      |> Guardian.Plug.sign_out
      |> put_flash(:info, "Signed out")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:info, "Not logged in")
      |> redirect(to: "/")
    end
  end

  defp auths(nil), do: []
  defp auths(%RaliGuardian.User{} = user) do
    Ecto.Model.assoc(user, :authorizations)
      |> Repo.all
      |> Enum.map(&(&1.provider))
  end
end
