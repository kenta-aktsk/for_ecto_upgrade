defmodule MediaSample.Enums.Status do
  use ExEnum
  row id: 0, type: :invalid, text: "invalid"
  row id: 1, type: :valid, text: "valid"
  accessor :type
  translate :text
end
