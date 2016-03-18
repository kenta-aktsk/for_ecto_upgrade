defmodule ForEctoUpgrade.Admin.CategoryController do
  use ForEctoUpgrade.Web, :admin_controller
  alias ForEctoUpgrade.Admin.CategoryService
  alias ForEctoUpgrade.Category

  plug :scrub_params, "category" when action in [:create, :update]

  def index(conn, _params) do
    categories = Repo.all(Category)
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Category.changeset(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.transaction(CategoryService.insert(changeset, category_params)) do
      {:ok, %{category: category, upload: _file}} ->
        conn
        |> put_flash(:info, "category created successfully.")
        |> redirect(to: admin_category_path(conn, :show, category))
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "category create failed")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.transaction(CategoryService.update(changeset, category_params)) do
      {:ok, %{category: category, upload: _file}} ->
        conn
        |> put_flash(:info, "category updated successfully.")
        |> redirect(to: admin_category_path(conn, :show, category))
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "category update failed")
        |> render("edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    case Repo.transaction(CategoryService.delete(category)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "category deleted successfully.")
        |> redirect(to: admin_category_path(conn, :index))
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, "category delete failed")
        |> redirect(to: admin_category_path(conn, :index))
    end
  end
end
