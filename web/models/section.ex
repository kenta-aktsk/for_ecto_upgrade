defmodule MediaSample.Section do
  use MediaSample.Web, :model
  use MediaSample.ModelStatusConcern
  use MediaSample.PreloadConcern
  alias MediaSample.{Entry, EntryTranslation, SectionTranslation}
  @mapping_type "section"

  schema "sections" do
    field :section_type, :integer
    field :content, :string
    field :image, :string
    field :seq, :integer
    field :status, :integer

    belongs_to :entry, Entry
    has_one :translation, SectionTranslation

    timestamps
  end

  @required_fields ~w(entry_id section_type seq status)a
  @optional_fields ~w()a

  def changeset(section, params \\ %{}) do
    section
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:entry_id)
  end

  def preload_all(query, locale) do
    from query, preload: [
      translation: ^SectionTranslation.translation_query(locale),
      entry: [translation: ^EntryTranslation.translation_query(locale)]
    ]
  end

  def mapping_type do
    @mapping_type
  end
end

