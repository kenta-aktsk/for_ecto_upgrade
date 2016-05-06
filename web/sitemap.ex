defmodule MediaSample.Sitemap do
  use PlainSitemap, default_host: MediaSample.Util.origin_uri
  alias MediaSample.{Repo, Entry, Gettext}

  urlset do
    add "/", changefreq: "hourly", priority: 1.0
    Entry |> Entry.valid |> Repo.all |> Enum.each(fn(entry) ->
      add "/#{Gettext.config[:default_locale]}/entries/#{entry.id}", lastmod: entry.updated_at, changefreq: "daily", priority: 1.0
    end)
  end

  def refresh(opts \\ [close: true]) do
    {:ok, _} = Application.ensure_all_started(:media_sample)
    PlainSitemap.refresh(opts[:app_dir] || Application.app_dir(:media_sample))
    if opts[:close], do: :init.stop()
  end
end
