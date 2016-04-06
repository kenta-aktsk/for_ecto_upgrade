defmodule MediaSample.EntryImageUploader do
  use MediaSample.BaseUploader, model: :entry, field: :image
  @versions [:medium, :small]

  def transform(:medium, _) do
    convert "300x200"
  end

  def transform(:small, _) do
    convert "150x100"
  end

  defp convert(size) when is_binary(size) do
    {:convert, "-thumbnail #{size}^ -gravity center -extent #{size} -format png", :png}
  end
end
