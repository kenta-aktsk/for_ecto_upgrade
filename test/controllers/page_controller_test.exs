defmodule MediaSample.PageControllerTest do
  use MediaSample.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) =~ page_path(conn, :index, conn.assigns.locale)
  end

  test "GET / with locale", %{conn: conn} do
    conn = get conn, page_path(conn, :index, conn.assigns.locale)
    assert html_response(conn, 200) =~ "Top"
  end
end
