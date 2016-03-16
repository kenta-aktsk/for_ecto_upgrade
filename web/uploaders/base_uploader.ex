defmodule ForEctoUpgrade.BaseUploader do
  defmacro __using__(_opts) do
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

      # Override the persisted filenames:
      def filename(version, _) do
        version
      end

      def url({file, scope}, version, options) do
        url = Arc.Actions.Url.url(__MODULE__, {file, scope}, version, options)
        url = if System.get_env("MIX_ENV") == "local", do: String.replace(url, Application.get_env(:arc, :base_upload_path), "/images"), else: url
        hash = :crypto.hash(:sha256, to_string(scope.__struct__) <> to_string(scope.id) <> to_string(scope.updated_at)) |> Base.encode16
        "#{url}?#{hash}"
      end

      # Provide a default URL if there hasn't been a file uploaded
      # def default_url(version, scope) do
      #   "/images/avatars/default_#{version}.png"
      # end

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
