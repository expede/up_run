defmodule UpRun.Recursion do
  def sum([]), do: 0
  def sum([value | list]), do: value + sum(list)
end
