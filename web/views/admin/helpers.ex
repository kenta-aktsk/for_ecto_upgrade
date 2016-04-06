defmodule MediaSample.Admin.Helpers do
  import Plug.Conn, only: [get_session: 2]
  def admin_logged_in?(conn) do
    case current_admin_user(conn) do
      nil -> false
      _ -> true
    end
  end

  def current_admin_user(conn) do 
    get_session(conn, :current_admin_user)
  end
end
