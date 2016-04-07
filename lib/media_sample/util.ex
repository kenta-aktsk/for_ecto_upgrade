defmodule MediaSample.Util do
  def pipe_if(p, condition, fun) do
    if condition, do: p |> fun.(), else: p
  end
end
