defmodule MediaSample.UserTranslation do
  use MediaSample.Web, :model
  use MediaSample.TranslationModelConcern,
    schema: "user_translations", target: MediaSample.User, required_fields: [:name], optional_fields: [:profile]
end
