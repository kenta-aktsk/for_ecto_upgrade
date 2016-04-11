defmodule MediaSample.TagTranslation do
  use MediaSample.Web, :model
  use Translator.TranslationModel,
    schema: "tag_translations", belongs_to: MediaSample.Tag, required_fields: [:name]
end
