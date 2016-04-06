defmodule MediaSample.Tag do
  use MediaSample.Web, :model
  use MediaSample.ModelStatusConcern

  schema "tags" do
    field :name, :string
    field :status, :integer

    many_to_many :entries, MediaSample.Entry, join_through: "entry_tags", on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name status)a
  @optional_fields ~w()a

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, @required_fields ++ @optional_fields)
  end
end
