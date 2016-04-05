defmodule ForEctoUpgrade.UserTest do
  use ForEctoUpgrade.ModelCase

  alias ForEctoUpgrade.{User, Enums.UserType, Enums.Status}

  @valid_attrs %{
    email: "test01@example.com", name: "some content", password: "012345678", password_confirmation: "012345678",
    profile: "some content", image: "some image path", user_type: UserType.reader.id, status: Status.valid.id}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid email format" do
    changeset = User.changeset(%User{}, %{@valid_attrs | email: "test01"})
    refute changeset.valid?

    changeset = User.changeset(%User{}, %{@valid_attrs | email: "test01example.com"})
    refute changeset.valid?

    changeset = User.changeset(%User{}, %{@valid_attrs | email: "test01@.example.com"})
    refute changeset.valid?
  end

  test "changeset with different password confirmation_attrs" do
    changeset = User.changeset(%User{}, %{@valid_attrs | password_confirmation: "012345679"})
    refute changeset.valid?
  end
end
