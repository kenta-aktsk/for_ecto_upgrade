defmodule MediaSample.Repo do
  @page_size 3
  use Ecto.Repo, otp_app: :media_sample
  use Scrivener, page_size: @page_size
  use ReadRepos, page_size: @page_size
end
