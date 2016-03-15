defmodule ForEctoUpgrade.UserImageUploader do
  use ForEctoUpgrade.BaseUploader

  def storage_dir(_version, {_file, scope}) do
    Path.join(Application.get_env(:arc, :base_upload_path), "user/#{scope.id}")
  end
end
