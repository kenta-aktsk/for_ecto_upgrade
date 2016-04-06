defmodule MediaSample.ControllerTestHelper do
  defmacro __using__(opts) do
    quote location: :keep do
      use Plug.Test
      @controller unquote(opts)[:controller] || raise ":controller must be given."

      def action(conn, action, params \\ %{}) do
        conn = conn
        |> put_private(:phoenix_controller, @controller)
        |> Phoenix.Controller.put_view(Phoenix.Controller.__view__(@controller))

        apply(@controller, action, [conn, params])
      end

      @signing_opts Plug.Session.init(
        store: :cookie,
        key: "_app",
        encryption_salt: "encrypted cookie salt",
        signing_salt: "signing salt"
      )

      defp with_session_and_flash(conn) do
        conn
        |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
        |> Plug.Session.call(@signing_opts)
        |> Plug.Conn.fetch_session
        |> Phoenix.ConnTest.fetch_flash
      end
    end
  end
end
