defmodule MediaSample.CategoryService do
  use MediaSample.Web, :service
  alias MediaSample.{CategoryTranslation, CategoryImageUploader}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:category, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:category], params, locale)))
    |> Multi.run(:upload, &(CategoryImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:category, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:category], params, locale)))
    |> Multi.run(:upload, &(CategoryImageUploader.upload(params["image"], &1)))
  end

  def delete(category) do
    Multi.new
    |> Multi.delete(:category, category)
    |> Multi.run(:delete, &(CategoryImageUploader.erase(&1)))
  end

  def insert_or_update_translation(category, category_params, locale) do
    translation_params = %{
      category_id: category.id,
      locale: locale,
      name: category_params["name"],
      description: category_params["description"]
    }
    if !category.translation || !Ecto.assoc_loaded?(category.translation) do
      changeset = CategoryTranslation.changeset(%CategoryTranslation{}, translation_params)
      Repo.insert(changeset)
    else
      changeset = CategoryTranslation.changeset(category.translation, translation_params)
      Repo.update(changeset)
    end
  end
end
