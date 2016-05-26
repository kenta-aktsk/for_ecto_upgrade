defmodule MediaSample.Search do
  import Tirexs.Bulk
  import Translator.TranslationHelpers
  import Ecto.Query, only: [where: 3]
  alias MediaSample.{Search.Definition, Repo, Entry, Section, Gettext, Util}

  def create_index, do: Gettext.supported_locales |> Enum.each(&(create_index(&1)))
  def create_index(locale) do
    delete_index(locale)
    index_name = get_index_name(locale)
    path = "/#{index_name}"
    payload = Tirexs.HTTP.encode(Definition.indices(locale))
    sign("POST", path, payload)
    {:ok, 200, _} = Tirexs.HTTP.post(index_name, payload)
  end

  def delete_index, do: Gettext.supported_locales |> Enum.each(&(delete_index(&1)))
  def delete_index(locale) do
    index_name = get_index_name(locale)
    path = "/#{index_name}"
    sign("HEAD", path)
    if Tirexs.Resources.exists?(index_name) do
      sign("DELETE", path)
      Tirexs.HTTP.delete(index_name)
    end
  end

  def put_document(locale, type, id, params) when is_list(params) do
    # we have to use Bulk API when indexing child document.
    # because aws_auth can't generate correct signature when path passed with query string parameter (e.x. "?parent=1")
    metadata =
      [_index: get_index_name(locale), _type: type, _id: id]
      |> Util.do_if(type == Section.mapping_type, &(&1 |> Keyword.put(:_parent, params[:entry_id])))
    document = Keyword.take(params, get_search_fields(locale, type))

    payload = Tirexs.Bulk.payload_as_string do
      [[[index: metadata], document]]
    end

    __MODULE__.bulk(payload)
  end

  def delete_document(type, id), do: Gettext.supported_locales |> Enum.each(&(delete_document(&1, type, id)))
  def delete_document(locale, type, id) do
    path = "/#{get_index_name(locale)}/#{type}/#{id}"
    sign("DELETE", path)
    Tirexs.HTTP.delete(path)
  end

  def import_documents, do: Gettext.supported_locales |> Enum.each(&(import_documents(&1)))
  def import_documents(locale) do
    import_entries(locale)
    import_sections(locale)
  end

  def import_entries(locale) do
    entries = Entry |> Entry.valid |> Entry.preload_all(locale) |> Repo.slave.all

    unless Blank.blank?(entries) do
      fields = get_document_fields(locale, Entry.mapping_type)
      documents = Enum.map(entries, fn(entry) ->
        Enum.map(fields, fn(field) ->
          if field == :id do
            {field, entry.id}
          else
            {field, translate(entry, field)}
          end
        end)
      end)

      payload = Tirexs.Bulk.bulk([index: get_index_name(locale), type: Entry.mapping_type]) do
        index documents
      end

      __MODULE__.bulk(payload)
    end
  end

  def import_sections(locale) do
    sections = Section |> Section.valid |> Section.preload_all(locale) |> Repo.slave.all

    unless Blank.blank?(sections) do
      fields = get_search_fields(locale, Section.mapping_type)

      documents = Enum.flat_map(sections, fn(section) ->
        document = Enum.map(fields, fn(field) ->
          {field, translate(section, field)}
        end)
        metadata = [index: [_index: get_index_name(locale), _type: Section.mapping_type, _parent: section.entry.id, _id: section.id]]
        [metadata, document]
      end)

      payload = Tirexs.Bulk.payload_as_string do
        documents
      end

      __MODULE__.bulk(payload)
    end
  end

  def search_entry_documents(locale, words) when is_binary(words) do
    payload =
      query(
        get_search_fields(locale, Entry.mapping_type),
        get_search_fields(locale, Section.mapping_type),
        Regex.replace(~r/\s|　/, words, " ")
      )
      |> Tirexs.HTTP.encode

    index_name = get_index_name(locale)
    path = "/#{index_name}/#{Entry.mapping_type}/_search"
    sign("POST", path, payload)
    {:ok, 200, result} = Tirexs.Resources.bump(payload)._search(index_name, Entry.mapping_type)
    result
  end

  def search_entries(locale, words) when is_binary(words) do
    result = search_entry_documents(locale, words)

    if result[:hits][:total] > 0 do
      ids = result[:hits][:hits] |> Enum.map(&(&1[:_id]))
      Entry |> Entry.preload_all(locale) |> where([e], e.id in ^ids) |> Repo.slave.all
    else
      []
    end
  end

  def query(entry_fields, section_fields, words) do
    [
      filter: [
        bool: [
          should: [
            [query: [multi_match: [fields: entry_fields, query: words]]],
            [has_child: [type: "section", query: [multi_match: [fields: section_fields, query: words]]]]
          ]
        ]
      ]
    ]
  end

  def bulk(payload) when is_binary(payload) do
    path = "/_bulk"
    sign("POST", path, payload)
    Tirexs.bump!(payload)._bulk()
  end

  def get_index_name(locale) do
    "media_sample_#{locale}"
  end

  def get_document_fields(locale, type) when is_binary(type) do
    index = Definition.indices(locale)
    index[:mappings][String.to_atom(type)][:properties] |> Enum.map(fn {k, _} -> k end)
  end

  def get_search_fields(locale, type) when is_binary(type) do
    get_document_fields(locale, type) |> List.delete(:id)
  end

  def sign(method, path), do: sign(method, path, "")
  def sign(method, path, payload) do
    config = Application.get_env(:media_sample, __MODULE__)
    signed_request = AWSAuth.sign_url(
      config[:access_key_id] || "",
      config[:secret_access_key] || "",
      method,
      config[:url] <> path,
      config[:region] || "",
      "es",
      %{},
      Timex.DateTime.now,
      payload
    )
    uri = URI.parse(signed_request)
    Application.put_env :tirexs, :uri, uri
  end
end
