defmodule ForEctoUpgrade.Admin.AdminUserAuthService do
  import Plug.Conn, only: [put_session: 3, configure_session: 2]
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

  def login(%Plug.Conn{} = conn, admin_user) do
    conn |> put_session(:current_admin_user, admin_user)
  end

  def logout(%Plug.Conn{} = conn) do
    conn |> configure_session(drop: true)
  end
end
