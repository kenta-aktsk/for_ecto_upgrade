defmodule Blank do
  def blank?(data) do
    Blank.Protocol.blank?(data)
  end

  def present?(data) do
    !blank?(data)
  end
end

defprotocol Blank.Protocol do
  def blank?(data)
end

defimpl Blank.Protocol, for: BitString do
  def blank?(""), do: true
  def blank?(_), do: false
end

defimpl Blank.Protocol, for: List do
  def blank?([]), do: true
  def blank?(_), do: false
end

defimpl Blank.Protocol, for: Map do
  def blank?(map), do: map_size(map) == 0
end
