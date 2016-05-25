defmodule MediaSample.SectionService do
  use MediaSample.Web, :service
  alias MediaSample.{Section, SectionTranslation, SectionImageUploader, Search, Util}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:section, changeset)
    |> Multi.run(:translation, &(SectionTranslation.insert_or_update(Repo, &1[:section], params, locale)))
    |> Multi.run(:put_search_document, &(put_search_document(&1[:section], params, locale)))
    |> Multi.run(:upload, &(SectionImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:section, changeset)
    |> Multi.run(:translation, &(SectionTranslation.insert_or_update(Repo, &1[:section], params, locale)))
    |> Multi.run(:put_search_document, &(put_search_document(&1[:section], params, locale)))
    |> Multi.run(:upload, &(SectionImageUploader.upload(params["image"], &1)))
  end

  def delete(section) do
    Multi.new
    |> Multi.delete(:section, section)
    |> Multi.run(:delete_search_document, &(delete_search_document(&1[:section])))
    |> Multi.run(:delete, &(SectionImageUploader.erase(&1)))
  end

  def put_search_document(section, params, locale) do
    Search.put_document(locale, Section.mapping_type, section.id, Util.atomify(params) |> Enum.into([]))
    {:ok, section}
  end

  def delete_search_document(section) do
    Search.delete_document(Section.mapping_type, section.id)
    {:ok, section}
  end
end
