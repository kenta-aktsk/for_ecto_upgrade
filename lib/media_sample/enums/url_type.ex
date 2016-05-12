defmodule MediaSample.Enums.UrlType do
  use ExEnum
  row id: 1, type: :home, root: nil
  row id: 2, type: :static, root: nil
  row id: 3, type: :entry, root: "entries"
  accessor :type
end
