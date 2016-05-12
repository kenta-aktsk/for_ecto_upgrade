defmodule MediaSample.Enums.StaticPageType do
  use ExEnum
  row id: 1, type: :about, root: "about"
  row id: 2, type: :faq, root: "faq"
  accessor :type
end
