defmodule MediaSample.Util do
  def do_if(p, condition, fun) do
    if condition, do: p |> fun.(), else: p
  end

  def origin_uri do
    config = Application.get_env(:media_sample, MediaSample.Endpoint)
    "#{config[:schema]}://#{config[:url][:host]}"
  end

  def rfc822_string(%Ecto.DateTime{} = datetime) do
    {:ok, dump} = Ecto.DateTime.dump(datetime)
    Timex.DateTime.from(dump)
    |> rfc822_string
  end

  def rfc822_string(%Timex.DateTime{} = datetime) do
    datetime |> Timex.format!("{RFC822}")
  end

  def atomify(map) when is_map(map) do
    Enum.map(map, fn {k, v} -> {String.to_atom(k), v} end) |> Enum.into(%{})
  end
end
