defmodule MediaSample.UserImageUploader do
  use MediaSample.BaseUploader, model: :user, field: :image
  @versions [:medium, :small]

  def transform(:medium, _) do
    convert "100x100"
  end

  def transform(:small, _) do
    convert "50x50"
  end

  defp convert(size) when is_binary(size) do
    {:convert, "-thumbnail #{size}^ -gravity center -extent #{size} -format png", :png}
  end
end
