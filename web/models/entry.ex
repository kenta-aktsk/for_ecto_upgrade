defmodule MediaSample.Entry do
  use MediaSample.Web, :model
  use MediaSample.ModelStatusConcern

  schema "entries" do
    field :title, :string
    field :content, :string
    field :image, :string
    field :status, :integer

    belongs_to :user, MediaSample.User
    belongs_to :category, MediaSample.Category
    many_to_many :tags, MediaSample.Tag, join_through: "entry_tags", on_delete: :delete_all

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

  def preload_all(query) do
    from query, preload: [:user, :category, :tags]
  end
end
