defmodule ForEctoUpgrade.Category do
  use ForEctoUpgrade.Web, :model

  schema "categories" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :status, :integer

    timestamps
  end

  @required_fields ~w(name description status)
  @optional_fields ~w()

  def changeset(category, params \\ %{}) do
    category
    |> cast(params, @required_fields ++ @optional_fields)
  end
end
