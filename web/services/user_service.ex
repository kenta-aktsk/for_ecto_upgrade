defmodule ForEctoUpgrade.UserService do
  use ForEctoUpgrade.Web, :service
  alias ForEctoUpgrade.User
  alias ForEctoUpgrade.UserImageUploader

  def insert(changeset, user_params) do
    Multi.new
    |> Multi.insert(:user, changeset)
    |> Multi.run(:upload, &(upload_image(user_params["image"], &1)))
  end

  def update(changeset, user_params) do
    Multi.new
    |> Multi.update(:user, changeset)
    |> Multi.run(:upload, &(upload_image(user_params["image"], &1)))
  end

  def delete(user) do
    Multi.new
    |> Multi.delete(:user, user)
    |> Multi.run(:delete, &(delete_image(&1)))
  end

  def upload_image(%Plug.Upload{} = image, %{user: user}) do
    case UserImageUploader.store({image, user}) do
      {:ok, file} -> 
        case Repo.update(Changeset.change(user, %{image: file})) do
          {:ok, user} -> {:ok, file}
          {:error, changeset} -> {:error, changeset.errors[:image]}
        end
      {:error, message} -> {:error, message}
    end
  end
  def upload_image(_, _), do: {:ok, nil}

  def delete_image(%{user: %{image: image} = user}) when not is_nil(image) do
    case UserImageUploader.delete({image, user}) do
      :ok -> {:ok, nil}
      {:error, reason} -> {:error, reason}
    end
  end
  def delete_image(_), do: {:ok, nil}
end
