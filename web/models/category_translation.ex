defmodule MediaSample.CategoryTranslation do
  use MediaSample.Web, :model

  schema "category_translations" do
    field :locale, :string
    field :name, :string
    field :description, :string

    belongs_to :category, MediaSample.Category

    timestamps
  end

  @required_fields ~w(category_id locale name description)a
  @optional_fields ~w()a

  def changeset(category_translation, params \\ %{}) do
    category_translation
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:category_id)
  end

  def translation_query(locale) do
    from t in __MODULE__, where: t.locale == ^locale
  end
end
