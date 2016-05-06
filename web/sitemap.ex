defmodule MediaSample.Sitemap do
  use PlainSitemap, app: :media_sample, default_host: MediaSample.Util.origin_uri
  alias MediaSample.{Repo, Entry, Gettext}

  urlset do
    add "/", changefreq: "hourly", priority: 1.0
    Entry |> Entry.valid |> Repo.all |> Enum.each(fn(entry) ->
      add "/#{Gettext.config[:default_locale]}/entries/#{entry.id}", lastmod: entry.updated_at, changefreq: "daily", priority: 1.0
    end)
  end
end
