defmodule ForEctoUpgrade.Locale do
  import Plug.Conn

  def init(opts), do: nil

  def call(conn, _opts) do
    locale = conn.params["locale"]
    IO.inspect "locale = #{inspect locale}"
    case conn.params["locale"] || get_session(conn, :locale) do
      nil     -> conn
      locale  ->
        Gettext.put_locale(ForEctoUpgrade.Gettext, locale)
        conn |> put_session(:locale, locale)
    end
  end
end
