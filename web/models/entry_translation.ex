defmodule MediaSample.EntryTranslation do
  use MediaSample.Web, :model

  schema "entry_translations" do
    field :locale, :string
    field :title, :string
    field :content, :string

    belongs_to :entry, MediaSample.Entry

    timestamps
  end

  @required_fields ~w(entry_id locale title content)a
  @optional_fields ~w()a

  def changeset(entry_translation, params \\ %{}) do
    entry_translation
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:entry_id)
  end

  def translation_query(locale) do
    from t in __MODULE__, where: t.locale == ^locale
  end
end
