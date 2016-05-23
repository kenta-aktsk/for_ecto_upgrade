defmodule MediaSample.BaseUploader do
  defmacro __using__(opts) do
    repo = Module.split(__CALLER__.module) |> List.first |> Module.safe_concat(Repo)
    quote location: :keep do
      use Arc.Definition
      import unquote(__MODULE__)
      alias Ecto.Changeset
      alias unquote(repo)
      unquote(config(opts))

      @extension_whitelist ~w(.jpg .jpeg .gif .png)
      @acl :public_read

      def validate({file, _}) do
        file_extension = file.file_name |> Path.extname |> String.downcase
        Enum.member?(@extension_whitelist, file_extension)
      end

      def __storage do
        Application.get_env(:arc, :storage)
      end

      def storage_dir(_version, {_file, scope}) do
        Path.join(Application.get_env(:arc, :base_upload_path), "#{to_string(@model)}/#{scope.id}")
      end

      def filename(version, _) do
        version
      end

      def default_url(version, _scope), do: default_url(version)
      def default_url(_version), do: nil

      def url({nil, _}, _, _), do: ""
      def url({file, scope}, version, options) do
        url = super({file, scope}, version, options) |> replace_url(System.get_env("MIX_ENV"))
        hash = Map.get(scope, @field)
        "#{url}?#{hash}"
      end

      defp replace_url(url, "local"), do: String.replace(url, Application.get_env(:arc, :base_upload_path), "/images")
      defp replace_url(url, _), do: url

      def upload(%Plug.Upload{} = file, %{@model => model}) do
        case __MODULE__.store({file, model}) do
          {:ok, _} ->
            # generate uuid to indicate this record is updated. (to refresh `updated_at` col)
            uuid = SecureRandom.uuid
            case Repo.update(Changeset.change(model, %{@field => uuid})) do
              {:ok, upload} -> {:ok, upload}
              {:error, changeset} -> {:error, changeset.errors[@field]}
            end
          {:error, message} -> {:error, message}
        end
      end
      def upload(_, _), do: {:ok, nil}

      def erase(%{@model => %{@field => file} = model}) when not is_nil(file) do
        case __MODULE__.delete({file, model}) do
          :ok -> {:ok, nil}
          {:error, reason} -> {:error, reason}
        end
      end
      def erase(_), do: {:ok, nil}

      defoverridable [validate: 1, __storage: 0, storage_dir: 2, filename: 2, default_url: 1, default_url: 2, url: 3, upload: 2, erase: 1]

      # Specify custom headers for s3 objects
      # Available options are [:cache_control, :content_disposition,
      #    :content_encoding, :content_length, :content_type,
      #    :expect, :expires, :storage_class, :website_redirect_location]
      #
      # def s3_object_headers(version, {file, scope}) do
      #   [content_type: Plug.MIME.path(file.file_name)]
      # end
    end
  end

  defp config(opts) do
    quote do
      @model unquote(opts)[:model] || raise ":model must be given."
      @field unquote(opts)[:field] || raise ":field must be given."
    end
  end
end
