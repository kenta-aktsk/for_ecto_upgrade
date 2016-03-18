defmodule ForEctoUpgrade.AdminUserTest do
  use ForEctoUpgrade.ModelCase

  alias ForEctoUpgrade.AdminUser

  @valid_attrs %{email: "some content", encrypted_password: "some content", name: "some content", status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AdminUser.changeset(%AdminUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AdminUser.changeset(%AdminUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
