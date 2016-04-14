defmodule MediaSample.Locale do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    supported_locales = MediaSample.Gettext.supported_locales
    cond do
      conn.params["locale"] in supported_locales ->
        conn |> assign_locale!(conn.params["locale"])
      Regex.match?(~r/^\/api/, conn.request_path) ->
        raise "every api needs locale."
      :else ->
        redirect_locale =
          conn
          |> extract_accept_languages
          |> Enum.filter(&(&1 in supported_locales))
          |> List.first || MediaSample.Gettext.config[:default_locale]
        conn |> Phoenix.Controller.redirect(to: "/#{redirect_locale}") |> halt
    end
  end

  defp extract_accept_languages(conn) do
    case conn |> get_req_header("accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_language_option/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(&(&1.tag))
      _ ->
        []
    end
  end

  defp parse_language_option(string) do
    captures = ~r/^(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i
    |> Regex.named_captures(string)

    quality = case Float.parse(captures["quality"] || "1.0") do
      {val, _} -> val
      _ -> 1.0
    end

    %{tag: captures["tag"], quality: quality}
  end

  defp assign_locale!(conn, locale) do
    Gettext.put_locale(MediaSample.Gettext, locale)
    conn |> assign(:locale, locale)
  end
end
