defmodule MediaSample.EntryTranslation do
  use MediaSample.Web, :model
  use MediaSample.TranslationModelConcern,
    schema: "entry_translations", belongs_to: MediaSample.Entry, required_fields: [:title, :content]
end
