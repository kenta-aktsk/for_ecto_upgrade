defmodule MediaSample.UserService do
  use MediaSample.Web, :service
  alias MediaSample.{UserTranslation, UserImageUploader}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:insert_or_update_translation, &(UserTranslation.insert_or_update(Repo, &1[:user], params, locale)))
    |> Multi.run(:upload, &(UserImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:user, changeset)
    |> Multi.run(:insert_or_update_translation, &(UserTranslation.insert_or_update(Repo, &1[:user], params, locale)))
    |> Multi.run(:upload, &(UserImageUploader.upload(params["image"], &1)))
  end

  def delete(user) do
    Multi.new
    |> Multi.delete(:user, user)
    |> Multi.run(:delete, &(UserImageUploader.erase(&1)))
  end
end
