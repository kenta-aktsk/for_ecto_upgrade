defmodule ForEctoUpgrade.User do
  use ForEctoUpgrade.Web, :model
  alias Ecto.Changeset
  alias ForEctoUpgrade.UserImageUploader
  @min_password_length 8
  @max_password_length 20

  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :profile, :string
    field :image, :string
    field :status, :integer

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email name profile status)a
  @optional_fields ~w()a

  def changeset(user, params \\ %{}) do
    {required_fields, optional_fields} = adjust_validation_fields(user, @required_fields, @optional_fields)

    user
    |> cast(params, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> check_password
  end

  defp adjust_validation_fields(%{__struct__: _} = user, required_fields, optional_fields)
    when is_list(required_fields) and is_list(optional_fields) do
    if for_insert?(user) do
      {append_password_fields(required_fields), optional_fields}
    else
      {required_fields, append_password_fields(optional_fields)}
    end
  end

  defp check_password(%Changeset{data: data, params: %{"password" => password, "password_confirmation" => password_confirmation}} = changeset) do
    if for_update?(data) && !password && !password_confirmation do
      changeset
    else
      changeset
      |> validate_length(:password, min: @min_password_length, max: @max_password_length)
      |> validate_confirmation(:password)
      |> put_encrypted_password
    end
  end
  defp check_password(changeset), do: changeset

  defp put_encrypted_password(%Changeset{params: %{"password" => password}} = changeset) do
    if password, do: put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password)), else: changeset
  end

  defp append_password_fields(fields) when is_list(fields) do
    fields ++ [:password, :password_confirmation]
  end
end
