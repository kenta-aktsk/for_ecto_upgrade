defmodule MediaSample.User do
  use MediaSample.Web, :model
  use MediaSample.UserModelPasswordConcern, min_password_length: 8, max_password_length: 10
  use MediaSample.ModelStatusConcern
  import MediaSample.ValidationConcern
  alias MediaSample.{Enums.UserType, Enums.Status}

  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :profile, :string
    field :image, :string
    field :user_type, :integer
    field :status, :integer

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :authorizations, MediaSample.Authorization

    timestamps
  end

  @required_fields ~w(email name status user_type)a
  @optional_fields ~w(profile)a

  def changeset(user, params \\ %{}) do
    {required_fields, optional_fields} = adjust_validation_fields(user, @required_fields, @optional_fields)

    user
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> check_password
    |> validate_email_format(:email)
    |> validate_inclusion(:user_type, UserType.select(:id))
    |> validate_inclusion(:status, Status.select(:id))
    |> unique_constraint(:email)
  end

  def simple_changeset(user, params \\ %{}) do
    user |> cast(params, @required_fields)
  end
end
