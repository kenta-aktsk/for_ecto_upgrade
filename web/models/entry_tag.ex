defmodule ForEctoUpgrade.EntryTag do
  use ForEctoUpgrade.Web, :model

  schema "entry_tags" do
    belongs_to :entry, ForEctoUpgrade.Entry
    belongs_to :tag, ForEctoUpgrade.Tag
  end

  @required_fields ~w(entry_id tag_id)a
  @optional_fields ~w()a

  def changeset(entry_tag, params \\ %{}) do
    entry_tag
    |> cast(params, @required_fields ++ @optional_fields)
  end
end
