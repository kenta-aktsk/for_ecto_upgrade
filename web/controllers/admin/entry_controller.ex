defmodule MediaSample.Admin.EntryController do
  use MediaSample.Web, :admin_controller
  use MediaSample.LocalizedController
  alias MediaSample.{EntryService, Entry}

  plug :scrub_params, "entry" when action in [:create, :update]

  def index(conn, _params, locale) do
    entries = Entry |> Entry.preload_all(locale) |> Repo.slave.all
    render(conn, "index.html", entries: entries)
  end

  def new(conn, _params, _locale) do
    changeset = Entry.changeset(%Entry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"entry" => entry_params}, locale) do
    changeset = Entry.changeset(%Entry{}, entry_params)

    case Repo.transaction(EntryService.insert(changeset, entry_params, locale)) do
      {:ok, %{entry: entry, upload: _upload}} ->
        conn
        |> put_flash(:info, gettext("%{name} created successfully.", name: gettext("Entry")))
        |> redirect(to: admin_entry_path(conn, :show, locale, entry)) |> halt
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} create failed.", name: gettext("Entry")))
        |> render("new.html", changeset: extract_changeset(failed_value, changeset))
    end
  end

  def show(conn, %{"id" => id}, locale) do
    entry = Entry |> Entry.preload_all(locale) |> Repo.slave.get!(id)
    render(conn, "show.html", entry: entry)
  end

  def edit(conn, %{"id" => id}, locale) do
    entry = Entry |> Entry.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Entry.changeset(entry)
    render(conn, "edit.html", entry: entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}, locale) do
    entry = Entry |> Entry.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Entry.changeset(entry, entry_params)

    case Repo.transaction(EntryService.update(changeset, entry_params, locale)) do
      {:ok, %{entry: entry, upload: _upload}} ->
        conn
        |> put_flash(:info, gettext("%{name} updated successfully.", name: gettext("Entry")))
        |> redirect(to: admin_entry_path(conn, :show, locale, entry)) |> halt
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} update failed.", name: gettext("Entry")))
        |> render("edit.html", entry: entry, changeset: extract_changeset(failed_value, changeset))
    end
  end

  def delete(conn, %{"id" => id}, locale) do
    entry = Repo.slave.get!(Entry, id)

    case Repo.transaction(EntryService.delete(entry)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("%{name} deleted successfully.", name: gettext("Entry")))
        |> redirect(to: admin_entry_path(conn, :index, locale)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} delete failed.", name: gettext("Entry")))
        |> redirect(to: admin_entry_path(conn, :index, locale)) |> halt
    end
  end
end
