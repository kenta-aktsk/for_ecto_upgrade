defmodule ForEctoUpgrade.Tag do
  use ForEctoUpgrade.Web, :model
  alias ForEctoUpgrade.Enums.Status

  schema "tags" do
    field :name, :string
    field :status, :integer

    many_to_many :entries, ForEctoUpgrade.Entry, join_through: "entry_tags", on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name status)a
  @optional_fields ~w()a

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, @required_fields ++ @optional_fields)
  end

  def valid(query) do
    from t in query, where: t.status == ^Status.valid.id
  end
end
