defmodule MediaSample.TagTranslation do
  use MediaSample.Web, :model

  schema "tag_translations" do
    field :locale, :string
    field :name, :string

    belongs_to :tag, MediaSample.Tag

    timestamps
  end

  @required_fields ~w(tag_id locale name)a
  @optional_fields ~w()a

  def changeset(tag_translation, params \\ %{}) do
    tag_translation
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:tag_id)
  end

  def translation_query(locale) do
    from t in __MODULE__, where: t.locale == ^locale
  end
end
