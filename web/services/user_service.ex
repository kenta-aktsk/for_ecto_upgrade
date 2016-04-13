defmodule MediaSample.UserService do
  use MediaSample.Web, :service
  alias MediaSample.{UserTranslation, UserImageUploader, Mailer}

  def insert(conn, changeset, params, locale) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:translation, &(UserTranslation.insert_or_update(Repo, &1[:user], params, locale)))
    |> Multi.run(:upload, &(UserImageUploader.upload(params["image"], &1)))
    |> Multi.run(:email, &(Mailer.deliver(Mailer.confirmation_email(conn, &1[:user].email, params["confirmation_token"]))))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:user, changeset)
    |> Multi.run(:translation, &(UserTranslation.insert_or_update(Repo, &1[:user], params, locale)))
    |> Multi.run(:upload, &(UserImageUploader.upload(params["image"], &1)))
  end

  def delete(user) do
    Multi.new
    |> Multi.delete(:user, user)
    |> Multi.run(:delete, &(UserImageUploader.erase(&1)))
  end
end
