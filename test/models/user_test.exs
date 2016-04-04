defmodule ForEctoUpgrade.UserTest do
  use ForEctoUpgrade.ModelCase

  alias ForEctoUpgrade.{User, Enums.UserType, Enums.Status}

  @valid_attrs %{
    email: "some content", name: "some content", password: "012345678", password_confirmation: "012345678",
    profile: "some content", image: "some image path", user_type: UserType.reader.id, status: Status.valid.id}
  @different_password_confirmation_attrs %{@valid_attrs | password_confirmation: "012345679"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with different_password_confirmation_attrs" do
    changeset = User.changeset(%User{}, @different_password_confirmation_attrs)
    refute changeset.valid?
  end
end
