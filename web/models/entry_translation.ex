defmodule MediaSample.EntryTranslation do
  use MediaSample.Web, :model
  use Translator.TranslationModel,
    schema: "entry_translations", belongs_to: MediaSample.Entry, required_fields: [:title, :description]
end
