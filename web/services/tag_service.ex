defmodule MediaSample.TagService do
  use MediaSample.Web, :service
  alias MediaSample.{TagTranslation}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:tag, changeset)
    |> Multi.run(:translation, &(TagTranslation.insert_or_update(Repo, &1[:tag], params, locale)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:tag, changeset)
    |> Multi.run(:translation, &(TagTranslation.insert_or_update(Repo, &1[:tag], params, locale)))
  end

  def delete(tag) do
    Multi.new
    |> Multi.delete(:tag, tag)
  end
end
