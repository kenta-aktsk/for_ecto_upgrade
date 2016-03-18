defmodule ForEctoUpgrade.Admin.CategoryService do
  use ForEctoUpgrade.Web, :service
  alias ForEctoUpgrade.CategoryImageUploader

  def insert(changeset, params) do
    Multi.new
    |> Multi.insert(:category, changeset)
    |> Multi.run(:upload, &(CategoryImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params) do
    Multi.new
    |> Multi.update(:category, changeset)
    |> Multi.run(:upload, &(CategoryImageUploader.upload(params["image"], &1)))
  end

  def delete(category) do
    Multi.new
    |> Multi.delete(:category, category)
    |> Multi.run(:delete, &(CategoryImageUploader.erase(&1)))
  end
end
