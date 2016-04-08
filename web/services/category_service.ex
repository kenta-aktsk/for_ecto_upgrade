defmodule MediaSample.CategoryService do
  use MediaSample.Web, :service
  alias MediaSample.{CategoryTranslation, CategoryImageUploader}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:category, changeset)
    |> Multi.run(:insert_or_update_translation, &(CategoryTranslation.insert_or_update(Repo, &1[:category], params, locale)))
    |> Multi.run(:upload, &(CategoryImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:category, changeset)
    |> Multi.run(:insert_or_update_translation, &(CategoryTranslation.insert_or_update(Repo, &1[:category], params, locale)))
    |> Multi.run(:upload, &(CategoryImageUploader.upload(params["image"], &1)))
  end

  def delete(category) do
    Multi.new
    |> Multi.delete(:category, category)
    |> Multi.run(:delete, &(CategoryImageUploader.erase(&1)))
  end
end
