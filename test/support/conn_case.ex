defmodule ReciperiWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Reciperi.Factory

      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias ReciperiWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ReciperiWeb.Endpoint

      # Helper method to add auhorization header
      # to a connection
      def auth_conn(conn, user \\ insert(:user)) do
        token = ReciperiWeb.Authentication.sign(%{role: user.role, id: user.id})
        put_req_header(conn, "authorization", "Bearer #{token}")
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Reciperi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Reciperi.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
