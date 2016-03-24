defmodule ForEctoUpgrade.UserAuthService do
  alias ForEctoUpgrade.User

  def auth_and_validate(auth, repo) do
    case repo.get_by(User, email: auth.uid) do
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
end
