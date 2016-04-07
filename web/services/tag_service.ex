defmodule MediaSample.TagService do
  use MediaSample.Web, :service
  alias MediaSample.{TagTranslation}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:tag, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:tag], params, locale)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:tag, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:tag], params, locale)))
  end

  def delete(tag) do
    Multi.new
    |> Multi.delete(:tag, tag)
  end

  def insert_or_update_translation(tag, tag_params, locale) do
    IO.puts "insert_or_update_translation tag = #{inspect tag}"
    translation_params = %{
      tag_id: tag.id,
      locale: locale,
      name: tag_params["name"]
    }
    if !tag.translation || !Ecto.assoc_loaded?(tag.translation) do
      changeset = TagTranslation.changeset(%TagTranslation{}, translation_params)
      Repo.insert(changeset)
    else
      changeset = TagTranslation.changeset(tag.translation, translation_params)
      Repo.update(changeset)
    end
  end
end
