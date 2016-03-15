defmodule ForEctoUpgrade.UserTest do
  use ForEctoUpgrade.ModelCase

  alias ForEctoUpgrade.User

  @valid_attrs %{email: "some content", encrypted_password: "some content", image: "some content", name: "some content", profile: "some content", status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
