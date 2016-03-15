defmodule ForEctoUpgrade.PageController do
  use ForEctoUpgrade.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
