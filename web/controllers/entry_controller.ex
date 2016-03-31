defmodule ForEctoUpgrade.EntryController do
  use ForEctoUpgrade.Web, :controller
  alias ForEctoUpgrade.Entry

  def index(conn, _params) do
    entries = Entry |> Entry.valid |> Entry.preload_all |> Repo.all
    render(conn, "index.html", entries: entries)
  end

  def show(conn, %{"id" => id}) do
    entry = Entry |> Entry.valid |> Entry.preload_all |> Repo.get!(id)
    render(conn, "show.html", entry: entry)
  end
end
