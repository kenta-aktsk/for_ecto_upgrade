defmodule MediaSample.EntryController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController
  alias MediaSample.Entry

  def index(conn, _params, locale) do
    entries = Entry |> Entry.valid |> Entry.preload_all(locale) |> Repo.slave.all
    render(conn, "index.html", entries: entries)
  end

  def show(conn, %{"id" => id}, locale) do
    entry = Entry |> Entry.valid |> Entry.preload_all(locale) |> Repo.slave.get!(id)
    render(conn, "show.html", entry: entry)
  end
end
