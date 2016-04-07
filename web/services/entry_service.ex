defmodule MediaSample.EntryService do
  use MediaSample.Web, :service
  alias MediaSample.{EntryTranslation, EntryTag, EntryImageUploader}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:entry, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:entry], params, locale)))
    |> Multi.run(:insert_entry_tags, &(insert_entry_tags(params["tags"], &1[:entry])))
    |> Multi.run(:upload, &(EntryImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    entry_id = changeset.data.id

    Multi.new
    |> Multi.update(:entry, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:entry], params, locale)))
    |> Multi.delete_all(:delete_entry_tags, from(r in EntryTag, where: r.entry_id == ^entry_id))
    |> Multi.run(:insert_entry_tags, &(insert_entry_tags(params["tags"], &1[:entry])))
    |> Multi.run(:upload, &(EntryImageUploader.upload(params["image"], &1)))
  end

  def delete(entry) do
    Multi.new
    |> Multi.delete(:entry, entry)
    |> Multi.run(:delete, &(EntryImageUploader.erase(&1)))
  end

  def insert_or_update_translation(entry, entry_params, locale) do
    translation_params = %{
      entry_id: entry.id,
      locale: locale,
      title: entry_params["title"],
      content: entry_params["content"]
    }
    if !entry.translation || !Ecto.assoc_loaded?(entry.translation) do
      changeset = EntryTranslation.changeset(%EntryTranslation{}, translation_params)
      Repo.insert(changeset)
    else
      changeset = EntryTranslation.changeset(entry.translation, translation_params)
      Repo.update(changeset)
    end
  end

  def insert_entry_tags(tags, entry) do
    entry_tags = Enum.map(tags, &([entry_id: entry.id, tag_id: String.to_integer(&1)]))
    count = length(entry_tags)
    {^count, list} = Repo.insert_all(EntryTag, entry_tags)
    {:ok, list}
  end
end
