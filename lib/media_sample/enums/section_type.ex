defmodule MediaSample.Enums.SectionType do
  use ExEnum
  row id: 1, type: :text, text: "text"
  row id: 2, type: :image, text: "image"
  row id: 3, type: :quote, text: "quote"
  row id: 4, type: :header, text: "header"
  accessor :type
  translate :text
end
