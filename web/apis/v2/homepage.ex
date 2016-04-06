defmodule MediaSample.API.V2.Homepage do
  use Maru.Router

  get "/" do
    text(conn, "V2 API works!")
  end
end
