defmodule MediaSample.Entry do
  use MediaSample.Web, :model
  use MediaSample.ModelStatusConcern
  alias MediaSample.{Gettext, EntryTranslation, CategoryTranslation, TagTranslation}

  schema "entries" do
    field :title, :string
    field :content, :string
    field :image, :string
    field :status, :integer

    belongs_to :user, MediaSample.User
    belongs_to :category, MediaSample.Category
    many_to_many :tags, MediaSample.Tag, join_through: "entry_tags", on_delete: :delete_all
    has_one :translation, MediaSample.EntryTranslation

    timestamps
  end

  @required_fields ~w(user_id category_id title content status)a
  @optional_fields ~w()a

  def changeset(entry, params \\ %{}) do
    entry
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:category_id)
  end

  def preload_all(query), do: preload_all(query, Gettext.config[:default_locale])
  def preload_all(query, locale) do
    from query, preload: [:user,
      translation: ^EntryTranslation.translation_query(locale),
      category: [translation: ^CategoryTranslation.translation_query(locale)],
      tags: [translation: ^TagTranslation.translation_query(locale)]
    ]
  end
end

