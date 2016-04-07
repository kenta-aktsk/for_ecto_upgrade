defmodule MediaSample.UserService do
  use MediaSample.Web, :service
  alias MediaSample.{UserTranslation, UserImageUploader}

  def insert(changeset, params, locale) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:user], params, locale)))
    |> Multi.run(:upload, &(UserImageUploader.upload(params["image"], &1)))
  end

  def update(changeset, params, locale) do
    Multi.new
    |> Multi.update(:user, changeset)
    |> Multi.run(:insert_or_update_translation, &(insert_or_update_translation(&1[:user], params, locale)))
    |> Multi.run(:upload, &(UserImageUploader.upload(params["image"], &1)))
  end

  def delete(user) do
    Multi.new
    |> Multi.delete(:user, user)
    |> Multi.run(:delete, &(UserImageUploader.erase(&1)))
  end

  def insert_or_update_translation(user, params, locale) do
    translation_params = %{
      user_id: user.id,
      locale: locale,
      name: params["name"],
      profile: params["profile"]
    }
    if !user.translation || !Ecto.assoc_loaded?(user.translation) do
      changeset = UserTranslation.changeset(%UserTranslation{}, translation_params)
      Repo.insert(changeset)
    else
      changeset = UserTranslation.changeset(user.translation, translation_params)
      Repo.update(changeset)
    end
  end
end
