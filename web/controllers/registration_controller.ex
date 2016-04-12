defmodule MediaSample.RegistrationController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController
  alias MediaSample.{UserService, User}

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params, locale) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, locale) do
    user_params = Map.merge(user_params, User.default_params)
    changeset = User.changeset(%User{}, user_params)

    case Repo.transaction(UserService.insert(changeset, user_params, locale)) do
      {:ok, %{user: user}} ->
        conn
        |> put_flash(:info, gettext("%{name} registed successfully.", name: gettext("User")))
        |> redirect(to: page_path(conn, :index, locale)) |> halt
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} regist failed.", name: gettext("User")))
        |> render("new.html", changeset: extract_changeset(failed_value, changeset))
    end
  end
end
