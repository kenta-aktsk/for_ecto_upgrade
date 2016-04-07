defmodule MediaSample.Admin.CategoryController do
  use MediaSample.Web, :admin_controller
  use MediaSample.LocalizedController
  alias MediaSample.{CategoryService, Category}

  plug :scrub_params, "category" when action in [:create, :update]

  def index(conn, _params, locale) do
    categories = Category |> Category.preload_all(locale) |> Repo.slave.all
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params, _locale) do
    changeset = Category.changeset(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}, locale) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.transaction(CategoryService.insert(changeset, category_params, locale)) do
      {:ok, %{category: category, upload: _file}} ->
        conn
        |> put_flash(:info, "category created successfully.")
        |> redirect(to: admin_category_path(conn, :show, locale, category)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "category create failed")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, locale) do
    category = Category |> Category.preload_all(locale) |> Repo.slave.get!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}, locale) do
    category = Category |> Category.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Category.changeset(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}, locale) do
    category = Category |> Category.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Category.changeset(category, category_params)

    case Repo.transaction(CategoryService.update(changeset, category_params, locale)) do
      {:ok, %{category: category, upload: _file}} ->
        conn
        |> put_flash(:info, "category updated successfully.")
        |> redirect(to: admin_category_path(conn, :show, locale, category)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "category update failed")
        |> render("edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, locale) do
    category = Repo.slave.get!(Category, id)

    case Repo.transaction(CategoryService.delete(category)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "category deleted successfully.")
        |> redirect(to: admin_category_path(conn, :index, locale)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "category delete failed")
        |> redirect(to: admin_category_path(conn, :index, locale)) |> halt
    end
  end
end
