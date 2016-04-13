defmodule MediaSample.RegistrationController do
  use MediaSample.Web, :controller
  use MediaSample.LocalizedController
  alias MediaSample.{UserService, User, Enums.Status}

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params, _locale) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}, locale) do
    user_params = user_params
      |> Map.merge(User.default_params)
      |> Map.put("confirmation_token", SecureRandom.urlsafe_base64)
      |> Map.put("confirmation_sent_at", Ecto.DateTime.utc)

    changeset = User.changeset(%User{}, user_params)

    case Repo.transaction(UserService.insert(conn, changeset, user_params, locale)) do
      {:ok, %{user: _}} ->
        conn
        |> put_flash(:info, gettext("Your account has been created successfully and confirmation e-mail was sent. please read confirmation instructions and activate your account."))
        |> redirect(to: page_path(conn, :index, locale)) |> halt
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} regist failed.", name: gettext("User")))
        |> render("new.html", changeset: extract_changeset(failed_value, changeset))
    end
  end

  def confirm(conn, %{"token" => token}, _locale) do
    user = User |> Repo.slave.get_by(confirmation_token: token)
    if user do
      changeset = User.changeset(user, %{"confirmation_token" => nil, "status" => Status.valid.id, "confirmed_at" => Ecto.DateTime.utc})
      case Repo.update(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, gettext("Your account has been activated successfully."))
          |> redirect(to: session_path(conn, :new, "identity")) |> halt
        {:error, _} ->
          conn
          |> put_flash(:error, gettext("Confirmation failed, something went wrong! Please try again later."))
          |> render(conn, "confirm.html")
      end
    else
      conn
      |> put_flash(:error, gettext("Confirmation failed. Your account has already been activated or confirmation token has been expired."))
      |> render("confirm.html")
    end
  end
end
