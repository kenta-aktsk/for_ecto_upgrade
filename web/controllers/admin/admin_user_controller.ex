defmodule MediaSample.Admin.AdminUserController do
  use MediaSample.Web, :admin_controller
  alias MediaSample.AdminUser

  plug :scrub_params, "admin_user" when action in [:create, :update]

  def index(conn, _params) do
    admin_users = Repo.slave.all(AdminUser)
    render(conn, "index.html", admin_users: admin_users)
  end

  def new(conn, _params) do
    changeset = AdminUser.changeset(%AdminUser{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin_user" => admin_user_params}) do
    changeset = AdminUser.changeset(%AdminUser{}, admin_user_params)

    case Repo.insert(changeset) do
      {:ok, _admin_user} ->
        conn
        |> put_flash(:info, "Admin user created successfully.")
        |> redirect(to: admin_admin_user_path(conn, :index, conn.assigns.locale)) |> halt
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    admin_user = Repo.slave.get!(AdminUser, id)
    render(conn, "show.html", admin_user: admin_user)
  end

  def edit(conn, %{"id" => id}) do
    admin_user = Repo.slave.get!(AdminUser, id)
    changeset = AdminUser.changeset(admin_user)
    render(conn, "edit.html", admin_user: admin_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "admin_user" => admin_user_params}) do
    admin_user = Repo.slave.get!(AdminUser, id)
    changeset = AdminUser.changeset(admin_user, admin_user_params)

    case Repo.update(changeset) do
      {:ok, admin_user} ->
        conn
        |> put_flash(:info, "Admin user updated successfully.")
        |> redirect(to: admin_admin_user_path(conn, :show, conn.assigns.locale, admin_user)) |> halt
      {:error, changeset} ->
        render(conn, "edit.html", admin_user: admin_user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin_user = Repo.slave.get!(AdminUser, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(admin_user)

    conn
    |> put_flash(:info, "Admin user deleted successfully.")
    |> redirect(to: admin_admin_user_path(conn, :index, conn.assigns.locale)) |> halt
  end
end
