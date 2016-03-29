defmodule ForEctoUpgrade.API.V1.Homepage do
  use Maru.Router

  get "/" do
    text(conn, "V1 API works!")
  end
end
