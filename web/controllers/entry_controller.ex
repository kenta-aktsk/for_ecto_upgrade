defmodule MediaSample.EntryController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController
  alias MediaSample.Entry

  def index(conn, params, locale) do
    page = Entry |> Entry.valid |> Entry.preload_all(locale) |> Repo.slave.paginate(params)
    render(conn, "index.html", entries: page.entries, page: page)
  end

  def show(conn, %{"id" => id}, locale) do
    entry = Entry |> Entry.valid |> Entry.preload_all(locale) |> Repo.slave.get!(id)
    render(conn, "show.html", entry: entry)
  end
end
