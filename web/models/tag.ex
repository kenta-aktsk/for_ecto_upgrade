defmodule ForEctoUpgrade.Tag do
  use ForEctoUpgrade.Web, :model
  use ForEctoUpgrade.ModelStatusConcern

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
end
