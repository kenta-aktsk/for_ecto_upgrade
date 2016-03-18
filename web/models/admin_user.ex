defmodule ForEctoUpgrade.AdminUser do
  use ForEctoUpgrade.Web, :model

  schema "admin_users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :status, :integer

    timestamps
  end

  @required_fields ~w(email name encrypted_password status)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
