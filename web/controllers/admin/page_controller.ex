defmodule ForEctoUpgrade.Admin.PageController do
  use ForEctoUpgrade.Web, :admin_controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
