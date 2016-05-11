defmodule MediaSample.FeedController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController
  import Ecto.Query, only: [limit: 2]
  alias MediaSample.Entry
  @feed_limit 25

  def rss(conn, _params, locale) do
    entries = Entry |> Entry.valid |> Entry.preload_all(locale) |> Entry.default_order |> limit(@feed_limit) |> Repo.slave.all
    conn
    |> put_resp_content_type("text/xml")
    |> render "rss.xml", conn: conn, locale: locale, entries: entries
  end
end
