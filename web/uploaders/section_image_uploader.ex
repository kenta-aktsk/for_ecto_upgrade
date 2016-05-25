defmodule MediaSample.SectionImageUploader do
  use MediaSample.BaseUploader, model: :section, field: :image
  @versions [:medium]

  def transform(:medium, _) do
    convert "300x200"
  end

  defp convert(size) when is_binary(size) do
    {:convert, "-thumbnail #{size}^ -gravity center -extent #{size} -format png", :png}
  end
end
