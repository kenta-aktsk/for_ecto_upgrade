defmodule MediaSample.LocalizedController do
  defmacro __using__(_) do
    quote do
      def action(conn, _opts) do
        apply(
          __MODULE__,
          action_name(conn),
          [
            conn,
            conn.params,
            conn.assigns.locale
          ]
        )
      end
    end
  end
end
