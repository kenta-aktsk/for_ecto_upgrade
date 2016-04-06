defmodule MediaSample.Locale do
  import Plug.Conn

  @no_locales Enum.join(["/admin", "/auth", "/logout"], "|") |> Regex.compile!

  def init(opts), do: opts

  def call(conn, _opts) do
    locale = conn.params["locale"]

    cond do
      locale in MediaSample.Gettext.supported_locales ->
        conn |> assign_locale!(locale)
      Regex.match?(@no_locales, conn.request_path) ->
        conn
      :else ->
        default_locale = MediaSample.Gettext.config[:default_locale]
        conn |> Phoenix.Controller.redirect(to: "/#{default_locale}#{conn.request_path}") |> halt
    end
  end

  defp assign_locale!(conn, locale) do
    Gettext.put_locale(MediaSample.Gettext, locale)
    conn |> assign(:locale, locale)
  end
end
