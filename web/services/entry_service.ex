defmodule MediaSample.EntryService do
  use MediaSample.Web, :service
  alias MediaSample.{Entry, EntryTranslation, EntryTag, EntryImageUploader, Search, Util}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:entry, changeset)
    |> Multi.run(:translation, &(EntryTranslation.insert_or_update(Repo, &1[:entry], params, locale)))
    |> Multi.run(:insert_entry_tags, &(insert_entry_tags(params["tags"], &1[:entry])))
    |> Multi.run(:put_search_document, &(put_search_document(&1[:entry], params, locale)))
    |> Multi.run(:upload, &(EntryImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    entry_id = changeset.data.id

    Multi.new
    |> Multi.update(:entry, changeset)
    |> Multi.run(:translation, &(EntryTranslation.insert_or_update(Repo, &1[:entry], params, locale)))
    |> Multi.delete_all(:delete_entry_tags, from(r in EntryTag, where: r.entry_id == ^entry_id))
    |> Multi.run(:insert_entry_tags, &(insert_entry_tags(params["tags"], &1[:entry])))
    |> Multi.run(:put_search_document, &(put_search_document(&1[:entry], params, locale)))
    |> Multi.run(:upload, &(EntryImageUploader.upload(params["image"], &1)))
  end

  def delete(entry) do
    Multi.new
    |> Multi.delete(:entry, entry)
    |> Multi.run(:delete_search_document, &(delete_search_document(&1[:entry])))
    |> Multi.run(:delete, &(EntryImageUploader.erase(&1)))
  end

  def insert_entry_tags(tags, entry) do
    entry_tags = Enum.map(tags, &([entry_id: entry.id, tag_id: Util.to_integer(&1)]))
    count = length(entry_tags)
    {^count, list} = Repo.insert_all(EntryTag, entry_tags)
    {:ok, list}
  end

  def put_search_document(entry, params, locale) do
    Search.put_document(locale, Entry.mapping_type, entry.id, Util.atomify(params) |> Enum.into([]))
    {:ok, entry}
  end

  def delete_search_document(entry) do
    Search.delete_document(Entry.mapping_type, entry.id)
    {:ok, entry}
  end
end
