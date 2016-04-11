defmodule MediaSample.UserTranslation do
  use MediaSample.Web, :model
  use Translator.TranslationModel,
    schema: "user_translations", belongs_to: MediaSample.User, required_fields: [:name], optional_fields: [:profile]
end
