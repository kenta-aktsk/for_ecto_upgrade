defmodule ForEctoUpgrade.Admin.EntryController do
  use ForEctoUpgrade.Web, :admin_controller
  alias ForEctoUpgrade.EntryService
  alias ForEctoUpgrade.Entry

  plug :scrub_params, "entry" when action in [:create, :update]

  def index(conn, _params) do
    entries = Entry |> Entry.preload_all |> Repo.all
    render(conn, "index.html", entries: entries)
  end

  def new(conn, _params) do
    changeset = Entry.changeset(%Entry{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"entry" => entry_params}) do
    changeset = Entry.changeset(%Entry{}, entry_params)

    case Repo.transaction(EntryService.insert(changeset, entry_params)) do
      {:ok, %{entry: entry, upload: _upload}} ->
        conn
        |> put_flash(:info, "entry created successfully.")
        |> redirect(to: admin_entry_path(conn, :show, conn.assigns.locale, entry)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "entry create failed")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Entry |> Entry.preload_all |> Repo.get!(id)
    render(conn, "show.html", entry: entry)
  end

  def edit(conn, %{"id" => id}) do
    entry = Entry |> Entry.preload_all |> Repo.get!(id)
    changeset = Entry.changeset(entry)
    render(conn, "edit.html", entry: entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Entry |> Entry.preload_all |> Repo.get!(id)
    changeset = Entry.changeset(entry, entry_params)

    case Repo.transaction(EntryService.update(changeset, entry_params)) do
      {:ok, %{entry: entry, upload: _upload}} ->
        conn
        |> put_flash(:info, "entry updated successfully.")
        |> redirect(to: admin_entry_path(conn, :show, conn.assigns.locale, entry)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "entry update failed")
        |> render("edit.html", entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Repo.get!(Entry, id)

    case Repo.transaction(EntryService.delete(entry)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "entry deleted successfully.")
        |> redirect(to: admin_entry_path(conn, :index, conn.assigns.locale)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "entry delete failed")
        |> redirect(to: admin_entry_path(conn, :index, conn.assigns.locale)) |> halt
    end
  end
end
