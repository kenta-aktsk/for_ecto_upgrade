defmodule ForEctoUpgrade.Admin.AdminUserAuthService do
  alias ForEctoUpgrade.{Repo, AdminUser}

  def auth_and_validate(auth) do
    case Repo.slave.get_by(AdminUser, email: auth.uid) do
      nil -> {:error, :not_found}
      admin_user ->
        case auth.credentials.other.password do
          pass when is_binary(pass) ->
            if Comeonin.Bcrypt.checkpw(auth.credentials.other.password, admin_user.encrypted_password) do
              {:ok, admin_user}
            else
              {:error, :password_does_not_match}
            end
          _ -> {:error, :password_required}
        end
    end
  end
end
