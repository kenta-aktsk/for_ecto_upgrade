defmodule ForEctoUpgrade.BaseUploader do
  defmacro __using__(model) when is_binary(model) do
    quote location: :keep do
      use Arc.Definition
      import unquote(__MODULE__)

      @versions [:medium, :small]
      @extension_whitelist ~w(.jpg .jpeg .gif .png)
      @acl :public_read

      def validate({file, _}) do   
        file_extension = file.file_name |> Path.extname |> String.downcase
        Enum.member?(@extension_whitelist, file_extension)
      end

      def transform(:medium, _) do
        convert "100x100"
      end

      def transform(:small, _) do
        convert "50x50"
      end

      defp convert(size) when is_binary(size) do
        {:convert, "-thumbnail #{size}^ -gravity center -extent #{size} -format png", :png}
      end

      def __storage do
        Application.get_env(:arc, :storage)
      end

      def storage_dir(_version, {_file, scope}) do
        Path.join(Application.get_env(:arc, :base_upload_path), "#{unquote(model)}/#{scope.id}")
      end

      def filename(version, _) do
        version
      end

      def default_url(version, _scope), do: default_url(version)
      def default_url(_version), do: nil

      def url({file, scope}, version, options) do
        url = super({file, scope}, version, options) |> replace_url(System.get_env("MIX_ENV"))
        hash = cache_bust(scope)
        "#{url}?#{hash}"
      end

      defp replace_url(url, "local"), do: String.replace(url, Application.get_env(:arc, :base_upload_path), "/images")
      defp replace_url(url, _), do: url

      defp cache_bust(%{__struct__: _, id: id, updated_at: updated_at} = scope) do
        :crypto.hash(:sha256, to_string(scope.__struct__) <> to_string(id) <> to_string(updated_at)) |> Base.encode16
      end

      defoverridable [storage_dir: 2, filename: 2, validate: 1, default_url: 1, default_url: 2, __storage: 0, url: 3]

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
end
