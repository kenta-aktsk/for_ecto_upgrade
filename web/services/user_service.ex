defmodule MediaSample.UserService do
  use MediaSample.Web, :service
  alias MediaSample.UserImageUploader

  def insert(changeset, user_params) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:upload, &(UserImageUploader.upload(user_params["image"], &1)))
  end

  def update(changeset, user_params) do
    Multi.new
    |> Multi.update(:user, changeset)
    |> Multi.run(:upload, &(UserImageUploader.upload(user_params["image"], &1)))
  end

  def delete(user) do
    Multi.new
    |> Multi.delete(:user, user)
    |> Multi.run(:delete, &(UserImageUploader.erase(&1)))
  end
end
