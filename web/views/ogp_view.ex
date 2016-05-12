defmodule MediaSample.OgpView do
  use MediaSample.Web, :view
  alias MediaSample.{Repo, Entry, EntryImageUploader, Enums.UrlType, Enums.StaticPageType, Util}

  def get_ogp_url(locale, path) do
    "#{Util.origin_uri}/#{locale}/#{path}"
  end

  def get_ogp_type(path) do
    url_type = get_url_type!(path)
    cond do
      url_type in [UrlType.home, UrlType.static] -> "website"
      :else -> "article"
    end
  end

  def get_ogp_title(locale, path) do
    url_type = get_url_type!(path)
    cond do
      url_type == UrlType.home ->
        gettext "MediaSample"
      url_type == UrlType.static ->
        static_page_type = get_static_page_type!(path)
        Gettext.gettext(MediaSample.Gettext, "title.#{static_page_type.type}")
      url_type == UrlType.entry ->
        entry = get_valid_entry!(locale, path)
        translate(entry, :title)
      :else ->
        raise "corresponding title is not defined. path = #{path}"
    end
  end

  def get_ogp_description(locale, path) do
    url_type = get_url_type!(path)
    cond do
      url_type in [UrlType.home, UrlType.static] ->
        gettext "Description of MediaSample"
      url_type == UrlType.entry ->
        entry = get_valid_entry!(locale, path)
        translate(entry, :content)
      :else ->
        raise "corresponding description is not defined. path = #{path}"
    end
  end

  def get_ogp_image(locale, path) do
    url_type = get_url_type!(path)
    cond do
      url_type == UrlType.entry ->
        entry = get_valid_entry!(locale, path)
        EntryImageUploader.url({entry.image, entry}, :medium)
      :else ->
        "#{Util.origin_uri}/images/phoenix.png"
    end
  end

  def get_url_type!(path) do
    cond do
      Blank.blank?(path) ->
        UrlType.home
      Regex.match?(static_page_regex, path) ->
        UrlType.static
      captures = Regex.named_captures(~r/^(?<root>\w+)\/\w+/i, path) ->
        UrlType.get_by!(root: captures["root"])
      :else ->
        raise "corresponding url type is not defined. path = #{path}"
    end
  end

  def get_static_page_type!(path) do
    if captures = Regex.named_captures(~r/^(?<root>\w+)\/?$/, path) do
      StaticPageType.get_by!(root: captures["root"])
    end || raise "corresponding static page type is not defined. path = #{path}"
  end

  def get_dynamic_page_id!(path) do
    if captures = Regex.named_captures(~r/^\w+\/(?<id>\w+)/, path) do
      {id, _} = Integer.parse(captures["id"])
      id
    end || raise "cannot get id from url. path = #{path}"
  end

  def get_valid_entry!(locale, path) do
    Entry |> Entry.valid |> Entry.preload_all(locale) |> Repo.slave.get!(get_dynamic_page_id!(path))
  end

  def entry_page?(path) do
    get_url_type!(path) == UrlType.entry
  end

  def static_page_regex do
    Regex.compile!("^#{Enum.map(StaticPageType.all, &(to_string(&1.type))) |> Enum.join("|")}\/?$", "i")
  end
end
