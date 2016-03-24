defmodule ForEctoUpgrade.Helpers do
  import Plug.Conn, only: [get_session: 2]
  def user_logged_in?(conn) do
    case current_user(conn) do
      nil -> false
      _ -> true
    end
  end

  def current_user(conn) do
    get_session(conn, :current_user)
  end
end
