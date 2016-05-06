defmodule MediaSample.Util do
  def pipe_if(p, condition, fun) do
    if condition, do: p |> fun.(), else: p
  end

  def origin_uri do
    config = Application.get_env(:media_sample, MediaSample.Endpoint)
    "#{config[:schema]}://#{config[:url][:host]}"
  end
end
