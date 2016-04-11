defmodule MediaSample.CategoryTranslation do
  use MediaSample.Web, :model
  use MediaSample.TranslationModelConcern,
    schema: "category_translations", belongs_to: MediaSample.Category, required_fields: [:name, :description]
end
