defmodule MediaSample.TagTranslation do
  use MediaSample.Web, :model
  use MediaSample.TranslationModelConcern,
    schema: "tag_translations", belongs_to: MediaSample.Tag, required_fields: [:name]
end
