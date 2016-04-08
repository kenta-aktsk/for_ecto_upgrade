defmodule MediaSample.CategoryTranslation do
  use MediaSample.Web, :model
  use MediaSample.TranslationModelConcern,
    schema: "category_translations", target: MediaSample.Category, required_fields: [:name, :description]
end
