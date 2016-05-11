defmodule MediaSample.FeedView do
  use MediaSample.Web, :view
  import XmlBuilder
  alias MediaSample.{EntryImageUploader, Util}

  def render("rss.xml", %{conn: conn, locale: locale, entries: entries}) do
    now = Timex.DateTime.now
    doc(:rss, %{version: "2.0"}, [
      element(:channel, %{}, [
        element(:title, gettext "MediaSample"),
        element(:link, page_url(conn, :index, locale)),
        element(:description, gettext "Description of MediaSample"),
        element(:language, locale),
        element(:lastBuildDate, Util.rfc822_string(now)),
        Enum.map(entries, fn(entry) ->
          link = entry_url(conn, :show, locale, entry)
          element(:item, %{}, [
            element(:title, translate(entry, :title)),
            element(:description, entry_description(entry)),
            element(:link, link),
            element(:guid, link),
            element(:pubDate, Util.rfc822_string(entry.inserted_at))
          ])
        end)
      ])
    ])
  end

  defp entry_description(entry) do
    {:cdata, "<img src=\"#{EntryImageUploader.url({entry.image, entry}, :medium)}\" alt=\"#{entry.image}\" />#{translate(entry, :title)}"}
  end
end
