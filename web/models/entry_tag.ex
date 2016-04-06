defmodule MediaSample.EntryTag do
  use MediaSample.Web, :model

  schema "entry_tags" do
    belongs_to :entry, MediaSample.Entry
    belongs_to :tag, MediaSample.Tag
  end

  @required_fields ~w(entry_id tag_id)a
  @optional_fields ~w()a

  def changeset(entry_tag, params \\ %{}) do
    entry_tag
    |> cast(params, @required_fields ++ @optional_fields)
  end
end
