defmodule ForEctoUpgrade.API do
  use Maru.Router

  rescue_from Unauthorized, as: e do
    IO.inspect e

    conn
    |> put_status(401)
    |> text("Unauthorized")
  end

  rescue_from :all, as: e do
    IO.inspect e

    conn
    |> put_status(500)
    |> text("Server Error")
  end

  resource "/v1" do
    mount ForEctoUpgrade.API.V1.Root
  end
  resource "/v2" do
    mount ForEctoUpgrade.API.V2.Root
  end
end
