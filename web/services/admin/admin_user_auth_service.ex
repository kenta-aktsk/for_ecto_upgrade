defmodule ForEctoUpgrade.Admin.AdminUserAuthService do
  alias Ueberauth.Auth
  alias ForEctoUpgrade.AdminUser
  import ForEctoUpgrade.Router.Helpers
  import ForEctoUpgrade.Admin.Helpers
  import Phoenix.Controller, only: [redirect: 2]

  def auth_and_validate(auth, repo) do
    case repo.get_by(AdminUser, email: auth.uid) do
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
