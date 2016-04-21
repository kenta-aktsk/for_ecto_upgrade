defmodule MediaSample.UserAuthService do
  use MediaSample.Web, :service
  alias MediaSample.{Repo, User, Enums.UserType, Enums.Status}
  alias MediaSample.Authorization

  def get_or_insert(auth) do
    case auth_and_validate(auth) do
      {:error, :not_found} -> register_user_from_auth(auth)
      {:error, reason} -> {:error, reason}
      {:ok, user} -> {:ok, user}
      authorization -> user_from_authorization(authorization, auth)
    end
  end

  def auth_and_validate(%{provider: :identity} = auth) do
    case Repo.slave.get_by(User, email: auth.uid, status: Status.valid.id) do
      nil -> {:error, :not_found}
      user ->
        case auth.credentials.other.password do
          pass when is_binary(pass) ->
            if Comeonin.Bcrypt.checkpw(auth.credentials.other.password, user.encrypted_password) do
              {:ok, user}
            else
              {:error, :password_does_not_match}
            end
          _ -> {:error, :password_required}
        end
    end
  end

  def auth_and_validate(%{email: email, password: password} = _auth) do
    case Repo.slave.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user ->
        if Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
          {:ok, user}
        else
          {:error, :password_does_not_match}
        end
    end
  end

  def auth_and_validate(auth) do
    case Repo.slave.get_by(Authorization, uid: auth.uid, provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      authorization -> authorization
    end
  end

  defp user_from_authorization(authorization, auth) do
    case Repo.slave.one(Ecto.assoc(authorization, :user)) do
      nil -> {:error, :user_not_found}
      user ->
        update_authorization(authorization, auth)
        {:ok, user}
    end
  end

  defp register_user_from_auth(%{provider: :identity} = _auth), do: {:error, :not_found}
  defp register_user_from_auth(auth) do
    case Repo.transaction(create_user_from_auth(auth)) do
      {:ok, %{user: user, authorization: _authorization}} -> {:ok, user}
      {:error, _failed_operation, _failed_value, _changes_so_far} -> {:error, :transaction_failed}
    end
  end

  defp create_user_from_auth(auth) do
    params = scrub(%{
      email: unique_email(auth.info.email),
      name: name_from_auth(auth),
      user_type: MediaSample.Enums.UserType.reader.id,
      status: MediaSample.Enums.Status.invalid.id
    })
    Multi.new
    |> Multi.insert(:user, User.simple_changeset(%User{}, params))
    |> Multi.run(:authorization, &insert_authorization(auth, &1[:user]))
  end

  defp insert_authorization(auth, user) do
    authorization = Ecto.build_assoc(user, :authorizations)
    params = scrub(%{
      provider: to_string(auth.provider),
      uid: uid_from_auth(auth),
      token: to_string(auth.credentials.token),
      refresh_token: to_string(auth.credentials.refresh_token),
      expires_at: auth.credentials.expires_at
    })
    Repo.insert Authorization.changeset(authorization, params)
  end

  defp update_authorization(authorization, auth) do
    params = scrub(%{
      token: to_string(auth.credentials.token),
      refresh_token: to_string(auth.credentials.refresh_token),
      expires_at: auth.credentials.expires_at
    })
    Repo.update Authorization.changeset(authorization, params)
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and String.strip(&1) != ""))
      |> Enum.join(" ")
    end
  end

  defp uid_from_auth(%{ provider: :slack } = auth), do: auth.credentials.other.user_id
  defp uid_from_auth(auth), do: auth.uid

  defp scrub(params) do
    Enum.filter(params, fn
      {_, val} when is_binary(val) -> String.strip(val) != ""
      {_, val} when is_nil(val) -> false
      _ -> true
    end) |> Enum.into(%{})
  end

  defp unique_email(email) do
    email || "#{SecureRandom.uuid}@#{MediaSample.Endpoint.config[:url][:host]}"
  end

  def editable_user?(%{__struct__: _} = user) do
    user.status == Status.valid.id && user.user_type != UserType.reader.id
  end
end
