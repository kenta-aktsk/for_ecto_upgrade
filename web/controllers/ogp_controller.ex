defmodule MediaSample.OgpController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController

  def index(conn, params, locale) do
    render(conn, "index.html", layout: false, conn: conn, locale: locale, path: String.lstrip(params["path"], ?/))
  end
end
