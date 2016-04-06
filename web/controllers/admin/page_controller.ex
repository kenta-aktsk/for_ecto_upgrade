defmodule MediaSample.Admin.PageController do
  use MediaSample.Web, :admin_controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
