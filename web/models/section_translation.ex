defmodule MediaSample.SectionTranslation do
  use MediaSample.Web, :model
  use Translator.TranslationModel,
    schema: "section_translations", belongs_to: MediaSample.Section, required_fields: [], optional_fields: [:content]
end
