defmodule MediaSample.SessionController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController
  import MediaSample.Helpers
  alias MediaSample.Gettext

  Enum.each Gettext.supported_locales, fn(locale) ->
    plug Ueberauth, base_path: "/#{locale}/auth"
  end
  plug :check_logged_in

  def new(conn, _params, _locale) do
    render(conn, "new.html")
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, _locale) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("new.html")
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, locale) do
    case UserAuthService.get_or_insert(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Signed in as %{name}", name: user.name))
        |> put_session(:current_user, user)
        |> redirect(to: page_path(conn, :index, locale)) |> halt
      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("Could not authenticate"))
        |> redirect(to: session_path(conn, :new, locale, "identity")) |> halt
    end
  end

  def delete(conn, _params, locale) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, gettext("%{name} signed out", name: gettext("User")))
    |> redirect(to: session_path(conn, :new, locale, "identity")) |> halt
  end

  def check_logged_in(conn, _params) do
    locale = Enum.find Gettext.supported_locales, fn(loc) ->
      conn.request_path == session_path(conn, :new, loc, "identity")
    end

    if locale && user_logged_in?(conn) do
      conn |> redirect(to: page_path(conn, :index, locale)) |> halt
    else
      conn
    end
  end
end
