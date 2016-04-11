defmodule MediaSample.AdminUser do
  use MediaSample.Web, :model
  use MediaSample.UserModelPasswordConcern, min_password_length: 4, max_password_length: 10
  use MediaSample.ModelStatusConcern
  import MediaSample.ValidationHelpers
  alias MediaSample.{Enums.Status}

  schema "admin_users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :status, :integer

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email name status)a
  @optional_fields ~w()a

  def changeset(admin_user, params \\ %{}) do
    {required_fields, optional_fields} = adjust_validation_fields(admin_user, @required_fields, @optional_fields)

    admin_user
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> check_password
    |> validate_email_format(:email)
    |> validate_inclusion(:status, Status.select(:id))
    |> unique_constraint(:email)
  end
end
