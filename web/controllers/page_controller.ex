defmodule MediaSample.PageController do
  use MediaSample.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
