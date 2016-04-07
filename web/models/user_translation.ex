defmodule MediaSample.UserTranslation do
  use MediaSample.Web, :model

  schema "user_translations" do
    field :locale, :string
    field :name, :string
    field :profile, :string

    belongs_to :user, MediaSample.User

    timestamps
  end

  @required_fields ~w(user_id locale name)a
  @optional_fields ~w(profile)a

  def changeset(user_translation, params \\ %{}) do
    user_translation
    |> cast(params, @required_fields ++ @optional_fields)
    |> foreign_key_constraint(:user_id)
  end

  def translation_query(locale) do
    from t in __MODULE__, where: t.locale == ^locale
  end
end
