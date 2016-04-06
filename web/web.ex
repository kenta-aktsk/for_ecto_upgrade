defmodule MediaSample.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use MediaSample.Web, :controller
      use MediaSample.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import MediaSample.ModelConcern
      require Logger
    end
  end

  def service do
    quote do
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      alias Ecto.Changeset
      alias Ecto.Multi
      alias MediaSample.Repo
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      use MediaSample.Controller
      alias MediaSample.UserAuthService
    end
  end

  def admin_controller do
    quote do
      # By indicating namespace, we can change module name prefix on LayoutView.
      # In this case, `MediaSample.Admin.LayoutView` will be used.
      use Phoenix.Controller, namespace: MediaSample.Admin
      use MediaSample.Controller
      import MediaSample.Admin.ControllerConcern
      alias MediaSample.Admin.AdminUserAuthService

      plug :check_logged_in

      def check_logged_in(conn, _params) do
        if conn.request_path != admin_session_path(conn, :new) && !admin_logged_in?(conn) do
          conn |> redirect(to: admin_session_path(conn, :new)) |> halt
        else
          conn
        end
      end

      defoverridable [check_logged_in: 2]
    end
  end

  def view do
    quote do
      use MediaSample.View
    end
  end

  def admin_view do
    quote do
      use MediaSample.View
      import MediaSample.Admin.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias MediaSample.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      import MediaSample.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

defmodule MediaSample.Controller do
  defmacro __using__(_) do
    quote do
      alias MediaSample.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import MediaSample.Router.Helpers
      import MediaSample.Gettext
      import MediaSample.Admin.Helpers
    end
  end
end

defmodule MediaSample.View do
  defmacro __using__(_) do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import MediaSample.Router.Helpers
      import MediaSample.ErrorHelpers
      import MediaSample.Gettext
      import MediaSample.Helpers
    end
  end
end
