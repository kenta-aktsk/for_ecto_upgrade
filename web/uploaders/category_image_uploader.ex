defmodule ForEctoUpgrade.CategoryImageUploader do
  use ForEctoUpgrade.BaseUploader, model: :category, field: :image
  @versions [:medium]

  def transform(:medium, _) do
    {:convert, "-thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
  end
end
