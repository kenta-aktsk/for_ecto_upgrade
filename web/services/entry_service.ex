defmodule MediaSample.EntryService do
  use MediaSample.Web, :service
  alias MediaSample.EntryTag
  alias MediaSample.EntryImageUploader

  def insert(changeset, params) do
    Multi.new
    |> Multi.insert(:entry, changeset)
    |> Multi.run(:insert_entry_tags, &(insert_entry_tags(params["tags"], &1[:entry])))
    |> Multi.run(:upload, &(EntryImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params) do
    entry_id = changeset.data.id

    Multi.new
    |> Multi.update(:entry, changeset)
    |> Multi.delete_all(:delete_entry_tags, from(r in EntryTag, where: r.entry_id == ^entry_id))
    |> Multi.run(:insert_entry_tags, &(insert_entry_tags(params["tags"], &1[:entry])))
    |> Multi.run(:upload, &(EntryImageUploader.upload(params["image"], &1)))
  end

  def delete(entry) do
    Multi.new
    |> Multi.delete(:entry, entry)
    |> Multi.run(:delete, &(EntryImageUploader.erase(&1)))
  end

  def insert_entry_tags(tags, entry) do
    entry_tags = Enum.map(tags, &([entry_id: entry.id, tag_id: String.to_integer(&1)]))
    count = length(entry_tags)
    {^count, list} = Repo.insert_all(EntryTag, entry_tags)
    {:ok, list}
  end
end
