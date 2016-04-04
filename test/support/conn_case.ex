defmodule ForEctoUpgrade.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias ForEctoUpgrade.Gettext

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias ForEctoUpgrade.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import ForEctoUpgrade.Router.Helpers

      # The default endpoint for testing
      @endpoint ForEctoUpgrade.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ForEctoUpgrade.Repo)
    status = unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ForEctoUpgrade.Repo, {:shared, self()})
    end || :ok

    {status, conn: Phoenix.ConnTest.conn |> Plug.Conn.assign(:locale, Gettext.config[:default_locale])}
  end
end
