defmodule MediaSample.API.V1.Session do
  use Maru.Router
  import Plug.Conn, only: [put_status: 2]
  alias MediaSample.{Repo, UserAuthService}, warn: false
  helpers MediaSample.API.V1.SharedParams

  resource "/session" do

    params do
      use [:auth]
    end
    post "/create" do
      case UserAuthService.auth_and_validate(params) do
        {:ok, user} ->
          {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
          conn
          |> put_status(:created)
          |> json(%{jwt: jwt})
        {:error, _reason} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Invalid email or password"})
      end
    end

    delete "/delete" do
      {:ok, claims} = Guardian.Plug.claims(conn)
      conn
      |> Guardian.Plug.current_token
      |> Guardian.revoke!(claims)

      conn
      |> json(%{ok: true})
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> json(%{error: "Not Authenticated"})
  end
end
