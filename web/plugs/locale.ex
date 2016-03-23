defmodule ForEctoUpgrade.Locale do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    locale = conn.params["locale"]

    cond do
      locale in ForEctoUpgrade.Gettext.supported_locales ->
        conn |> assign_locale!(locale)
      Regex.match?(~r/^\/admin/, conn.request_path) ->
        conn
      :else ->
        default_locale = ForEctoUpgrade.Gettext.config[:default_locale]
        conn |> Phoenix.Controller.redirect(to: "/#{default_locale}#{conn.request_path}")
    end
  end

  defp assign_locale!(conn, locale) do
    Gettext.put_locale(ForEctoUpgrade.Gettext, locale)
    conn |> assign(:locale, locale)
  end
end
