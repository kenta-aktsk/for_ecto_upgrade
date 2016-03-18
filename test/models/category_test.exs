defmodule ForEctoUpgrade.CategoryTest do
  use ForEctoUpgrade.ModelCase

  alias ForEctoUpgrade.Category

  @valid_attrs %{description: "some content", image: "some content", name: "some content", status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
