defmodule MediaSample.CategoryImageUploader do
  use MediaSample.BaseUploader, model: :category, field: :image
  @versions [:medium]

  def transform(:medium, _) do
    {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
  end
end
