defmodule ForEctoUpgrade.SessionController do
  use ForEctoUpgrade.Web, :controller
  import ForEctoUpgrade.Helpers
  alias ForEctoUpgrade.Gettext

  plug Ueberauth, base_path: "/auth"
  plug :check_logged_in

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("new.html")
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserAuthService.get_or_insert(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.name}")
        |> put_session(:current_user, user)
        |> redirect(to: page_path(conn, :index, Gettext.config[:default_locale])) |> halt
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not authenticate")
        |> redirect(to: session_path(conn, :new, "identity")) |> halt
    end
  end

  def delete(conn, _params) do
    conn
      |> configure_session(drop: true)
      |> put_flash(:info, "user signed out")
      |> redirect(to: session_path(conn, :new, "identity")) |> halt
  end

  def check_logged_in(conn, _params) do
    if conn.request_path == session_path(conn, :new, "identity") && user_logged_in?(conn) do
      conn |> redirect(to: page_path(conn, :index, Gettext.config[:default_locale])) |> halt
    else
      conn
    end
  end
end
