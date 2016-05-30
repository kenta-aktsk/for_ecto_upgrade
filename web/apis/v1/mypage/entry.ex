defmodule MediaSample.API.V1.Mypage.Entry do
  use Maru.Router
  import Phoenix.View, only: [render: 3], warn: false
  alias MediaSample.{Repo, Category, Entry, Section, API.EntryView, UserAuthService, EntryService, SectionService}, warn: false
  helpers MediaSample.API.V1.SharedParams

  plug Guardian.Plug.EnsureAuthenticated, handler: MediaSample.API.V1.Session

  def check_user_permission!(user) do
    unless UserAuthService.editable_user?(user), do: raise "user doesn't have authority to post an entry."
  end

  def check_owner!(entry, user) do
    unless entry.user.id == user.id, do: raise "user is not the owner of this entry."
  end

  def make_temp_image(image) when is_binary(image) do
    scheme = get_data_uri_scheme(image)
    if scheme do
      Temp.track! # cleanup temp file automatically
      {:ok, file, path} = Temp.open
      IO.binwrite(file, Base.decode64!(scheme.data))
      File.close file
      %Plug.Upload{
        path: path,
        content_type: scheme.type,
        filename: "#{SecureRandom.uuid}.#{scheme.ext}"
      }
    else
      nil
    end
  end

  def get_data_uri_scheme(image) when is_binary(image) do
    captures =
      ~r/data:(?<type>.*?);base64,(?<data>.*)$/i
      |> Regex.named_captures(image)
    if captures do
      %{
        type: captures["type"],
        data: captures["data"],
        ext: String.split(captures["type"], "/") |> Enum.at(1)
      }
    else
      nil
    end
  end

  def build_entry_multi(user, params, locale) do
    if !Map.has_key?(params, "id") do
      params =
        params
        |> Map.put("user_id", user.id)
        |> Map.put("image", make_temp_image(params["image"]))
      changeset = Entry.changeset(%Entry{}, params)
      EntryService.insert(changeset, params, locale)
    else
      entry = Entry |> Entry.preload_all(locale) |> Repo.get!(params["id"])
      check_owner!(entry, user)
      params = Map.put(params, "image", make_temp_image(params["image"]))
      changeset = Entry.changeset(entry, params)
      EntryService.update(changeset, params, locale)
    end
  end

  def build_section_multi(entry, params, locale) do
    if !Map.has_key?(params, "id") do
      params =
        params
        |> Map.put("entry_id", entry.id)
        |> Map.put("image", make_temp_image(params["image"]))
      changeset = Section.changeset(%Section{}, params)
      SectionService.insert(changeset, params, locale)
    else
      section = Section |> Section.preload_all(locale) |> Repo.get!(params["id"])
      params = Map.put(params, "image", make_temp_image(params["image"]))
      changeset = Section.changeset(section, params)
      SectionService.update(changeset, params, locale)
    end
  end

  resource "/entry" do
    params do
      use [:entry]
    end
    post "/save" do
      user = Guardian.Plug.current_resource(conn)
      check_user_permission!(user)
      _ = Category |> Category.valid |> Repo.slave.get!(params.category_id) # only check if valid category exists.

      params = Guardian.Utils.stringify_keys(params)
      locale = conn.assigns.locale

      try do
        result = Repo.transaction(fn ->
          entry_multi = build_entry_multi(user, params, locale)
          case Repo.transaction(entry_multi) do
            {:ok, %{entry: entry}} ->
              unless Blank.blank?(params["sections"]) do
                Enum.each(params["sections"], fn(section_params) ->
                  section_multi = build_section_multi(entry, section_params, locale)
                  case Repo.transaction(section_multi) do
                    {:ok, _} -> :ok
                    {:error, _failed_operation, _failed_value, _changes_so_far} ->
                      raise "section save failed."
                  end
                end)
              end
              entry
            {:error, _failed_operation, _failed_value, _changes_so_far} ->
              raise "entry save failed."
          end
        end)

        case result do
          {:ok, entry} ->
            entry = Entry |> Entry.preload_all(locale) |> Repo.get!(entry.id)
            conn |> json(render(EntryView, "show.json", entry: entry))
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end
      rescue
        e in RuntimeError ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: e.message})
      end
    end

    params do
      use [:id]
    end
    get ":id" do
      entry = Entry |> Entry.preload_all(conn.assigns.locale) |> Repo.slave.get!(params[:id])
      conn |> json(render(EntryView, "show.json", entry: entry))
    end
  end
end
