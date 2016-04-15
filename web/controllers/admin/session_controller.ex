defmodule MediaSample.Admin.SessionController do
  use MediaSample.Web, :admin_controller
  use MediaSample.LocalizedController
  alias Ueberauth.Strategy.Helpers
  alias MediaSample.Gettext

  Enum.each Gettext.supported_locales, fn(locale) ->
    plug Ueberauth, base_path: "/#{locale}/admin/auth"
  end
  plug :check_logged_in

  def new(conn, _params, _locale) do
    render(conn, "new.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, locale) do
    case AdminUserAuthService.auth_and_validate(auth) do
      {:ok, admin_user} ->
        conn
        |> put_flash(:info, gettext("Signed in as %{name}", name: admin_user.name))
        |> AdminUserAuthService.login(admin_user)
        |> redirect(to: admin_page_path(conn, :index, locale)) |> halt
      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("Could not authenticate"))
        |> redirect(to: admin_session_path(conn, :new, locale)) |> halt
    end
  end

  def delete(conn, _params, locale) do
    conn
    |> AdminUserAuthService.logout
    |> put_flash(:info, gettext("%{name} signed out", name: gettext("AdminUser")))
    |> redirect(to: admin_session_path(conn, :new, locale)) |> halt
  end

  def check_logged_in(conn, _params) do
    locale = Enum.find Gettext.supported_locales, fn(loc) ->
      conn.request_path == admin_session_path(conn, :new, loc)
    end

    if locale && admin_logged_in?(conn) do
      conn |> redirect(to: admin_page_path(conn, :index, locale)) |> halt
    else
      conn
    end
  end
end
