defmodule MediaSample.Admin.AdminUserControllerTest do
  use MediaSample.ConnCase, async: true
  use MediaSample.ControllerTestHelper, controller: MediaSample.Admin.AdminUserController

  alias MediaSample.{AdminUser, Admin.AdminUserAuthService, Enums.Status}
  @valid_attrs %{email: "some content", encrypted_password: "some content", name: "some content", status: Status.valid.id}
  @invalid_attrs %{}

  defp with_logged_in_user(conn) do
    admin_user = Repo.insert!(%AdminUser{id: 1, email: "testadmin01@example.com", name: "testadmin01", encrypted_password: "dummy", status: Status.valid.id})
    conn
    |> AdminUserAuthService.login(admin_user)
  end

  test "redirect to admin login page if not authenticated", %{conn: conn} do
    conn = get conn, admin_admin_user_path(conn, :index, conn.assigns.locale)
    assert redirected_to(conn) =~ admin_session_path(conn, :new, conn.assigns.locale)
  end

  test "lists all entries on index", %{conn: conn} do
    conn =
      conn
      |> with_session_and_flash
      |> with_logged_in_user
      |> action(:index)
    assert html_response(conn, 200) =~ "Listing admin users"
  end

  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, admin_user_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New admin user"
  # end

  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, admin_user_path(conn, :create), admin_user: @valid_attrs
  #   assert redirected_to(conn) == admin_user_path(conn, :index)
  #   assert Repo.get_by(AdminUser, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, admin_user_path(conn, :create), admin_user: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New admin user"
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   admin_user = Repo.insert! %AdminUser{}
  #   conn = get conn, admin_user_path(conn, :show, admin_user)
  #   assert html_response(conn, 200) =~ "Show admin user"
  # end

  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, admin_user_path(conn, :show, -1)
  #   end
  # end

  # test "renders form for editing chosen resource", %{conn: conn} do
  #   admin_user = Repo.insert! %AdminUser{}
  #   conn = get conn, admin_user_path(conn, :edit, admin_user)
  #   assert html_response(conn, 200) =~ "Edit admin user"
  # end

  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   admin_user = Repo.insert! %AdminUser{}
  #   conn = put conn, admin_user_path(conn, :update, admin_user), admin_user: @valid_attrs
  #   assert redirected_to(conn) == admin_user_path(conn, :show, admin_user)
  #   assert Repo.get_by(AdminUser, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   admin_user = Repo.insert! %AdminUser{}
  #   conn = put conn, admin_user_path(conn, :update, admin_user), admin_user: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit admin user"
  # end

  # test "deletes chosen resource", %{conn: conn} do
  #   admin_user = Repo.insert! %AdminUser{}
  #   conn = delete conn, admin_user_path(conn, :delete, admin_user)
  #   assert redirected_to(conn) == admin_user_path(conn, :index)
  #   refute Repo.get(AdminUser, admin_user.id)
  # end
end
