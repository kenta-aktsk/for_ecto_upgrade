defmodule MediaSample.TagTranslation do
  use MediaSample.Web, :model
  use MediaSample.TranslationModelConcern,
    schema: "tag_translations", target: MediaSample.Tag, required_fields: [:name]
end
