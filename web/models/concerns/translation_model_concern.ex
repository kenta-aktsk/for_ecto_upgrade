defmodule MediaSample.TranslationModelConcern do
  defmacro __using__(opts) do
    quote location: :keep do
      unquote(config(opts))

      target_underscore = Module.split(@target) |> List.last |> Macro.underscore
      @target_underscore_atom String.to_atom(target_underscore)
      @target_id_field String.to_atom(target_underscore <> "_id")

      schema @schema do
        field :locale, :string
        Enum.each @required_fields ++ @optional_fields, fn(f) ->
          field f, :string
        end

        belongs_to @target_underscore_atom, @target

        timestamps
      end

      def changeset(translation, params \\ %{}) do
        required_fields = @required_fields ++ [:locale, @target_id_field]
        translation
        |> cast(params, required_fields ++ @optional_fields)
        |> validate_required(required_fields)
        |> foreign_key_constraint(@target_id_field)
      end

      def translation_query(locale) do
        from t in __MODULE__, where: t.locale == ^locale
      end

      def insert_or_update(repo, target, target_params, locale) do
        default_params = %{
          @target_id_field => target.id,
          locale: locale
        }

        translation_params = Enum.into @required_fields ++ @optional_fields, default_params, fn(f) ->
          {f, target_params[to_string(f)]}
        end

        if !Map.get(target, @assoc) || !Ecto.assoc_loaded?(Map.get(target, @assoc)) do
          changeset = __MODULE__.changeset(%__MODULE__{}, translation_params)
          repo.insert(changeset)
        else
          changeset = __MODULE__.changeset(Map.get(target, @assoc), translation_params)
          repo.update(changeset)
        end
      end
    end
  end

  defp config(opts) do
    quote do
      @schema unquote(opts)[:schema] || raise ":schema must be given."
      @target unquote(opts)[:target] || raise ":target must be given."
      @required_fields unquote(opts)[:required_fields] || raise ":required_fields must be given."
      @optional_fields unquote(opts)[:optional_fields] || []
      @assoc unquote(opts)[:assoc] || :translation
    end
  end
end
