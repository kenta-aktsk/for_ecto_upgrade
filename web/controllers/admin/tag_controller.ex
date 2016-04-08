defmodule MediaSample.Admin.TagController do
  use MediaSample.Web, :admin_controller
  use MediaSample.LocalizedController
  alias MediaSample.{TagService, Tag}

  plug :scrub_params, "tag" when action in [:create, :update]

  def index(conn, _params, locale) do
    tags = Tag |> Tag.preload_all(locale) |> Repo.slave.all
    render(conn, "index.html", tags: tags)
  end

  def new(conn, _params, _locale) do
    changeset = Tag.changeset(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}, locale) do
    changeset = Tag.changeset(%Tag{}, tag_params)

    case Repo.transaction(TagService.insert(changeset, tag_params, locale)) do
      {:ok, %{tag: tag}} ->
        conn
        |> put_flash(:info, "tag created successfully.")
        |> redirect(to: admin_tag_path(conn, :show, locale, tag)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "tag create failed")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, locale) do
    tag = Tag |> Tag.preload_all(locale) |> Repo.slave.get!(id)
    render(conn, "show.html", tag: tag)
  end

  def edit(conn, %{"id" => id}, locale) do
    tag = Tag |> Tag.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Tag.changeset(tag)
    render(conn, "edit.html", tag: tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}, locale) do
    tag = Tag |> Tag.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Tag.changeset(tag, tag_params)

    case Repo.transaction(TagService.update(changeset, tag_params, locale)) do
      {:ok, %{tag: tag}} ->
        conn
        |> put_flash(:info, "tag updated successfully.")
        |> redirect(to: admin_tag_path(conn, :show, locale, tag)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "tag update failed")
        |> render("edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, locale) do
    tag = Repo.slave.get!(Tag, id)

    case Repo.transaction(TagService.delete(tag)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "tag deleted successfully.")
        |> redirect(to: admin_tag_path(conn, :index, locale)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "tag delete failed")
        |> redirect(to: admin_tag_path(conn, :index, locale)) |> halt
    end
  end
end
