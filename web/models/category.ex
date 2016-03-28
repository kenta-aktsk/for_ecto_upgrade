defmodule ForEctoUpgrade.Category do
  use ForEctoUpgrade.Web, :model
  use ForEctoUpgrade.ModelStatusConcern

  schema "categories" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :status, :integer

    timestamps
  end

  @required_fields ~w(name description status)a
  @optional_fields ~w()a

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, @required_fields ++ @optional_fields)
  end
end
