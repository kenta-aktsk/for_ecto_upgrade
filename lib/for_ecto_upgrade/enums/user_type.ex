defmodule ForEctoUpgrade.Enums.UserType do
  use ExEnum
  row id: 1, type: :reader, text: "reader"
  row id: 2, type: :editor, text: "editor"
  row id: 9, type: :admin, text: "admin"
  accessor :type
  translate :text
end
