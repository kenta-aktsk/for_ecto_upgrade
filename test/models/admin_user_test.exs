defmodule ForEctoUpgrade.AdminUserTest do
  use ForEctoUpgrade.ModelCase

  alias ForEctoUpgrade.{AdminUser, Enums.Status}

  @valid_attrs %{email: "admin01@example.com", name: "some content", password: "0123", password_confirmation: "0123", status: Status.valid.id}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AdminUser.changeset(%AdminUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AdminUser.changeset(%AdminUser{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid email format" do
    changeset = AdminUser.changeset(%AdminUser{}, %{@valid_attrs | email: "admin01"})
    refute changeset.valid?

    changeset = AdminUser.changeset(%AdminUser{}, %{@valid_attrs | email: "admin01example.com"})
    refute changeset.valid?

    changeset = AdminUser.changeset(%AdminUser{}, %{@valid_attrs | email: "admin01@.example.com"})
    refute changeset.valid?
  end

  test "changeset with different password confirmation_attrs" do
    changeset = AdminUser.changeset(%AdminUser{}, %{@valid_attrs | password_confirmation: "012X"})
    refute changeset.valid?
  end
end
