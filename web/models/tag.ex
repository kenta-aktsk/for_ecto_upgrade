defmodule MediaSample.Tag do
  use MediaSample.Web, :model
  use MediaSample.ModelStatusConcern
  use MediaSample.PreloadConcern
  alias MediaSample.TagTranslation

  schema "tags" do
    field :name, :string
    field :status, :integer

    has_one :translation, MediaSample.TagTranslation
    many_to_many :entries, MediaSample.Entry, join_through: "entry_tags", on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name status)a
  @optional_fields ~w()a

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def preload_all(query, locale) do
    from query, preload: [translation: ^TagTranslation.translation_query(locale)]
  end
end
