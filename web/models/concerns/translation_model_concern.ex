defmodule MediaSample.TranslationModelConcern do
  defmacro __using__(opts) do
    quote location: :keep do
      unquote(config(opts))

      parent = Module.split(@belongs_to) |> List.last |> Macro.underscore
      @parent_atom String.to_atom(parent)
      @parent_id_field String.to_atom(parent <> "_id")

      schema @schema do
        field :locale, :string
        Enum.each @required_fields ++ @optional_fields, fn(f) ->
          field f, :string
        end

        belongs_to @parent_atom, @belongs_to

        timestamps
      end

      def changeset(translation, params \\ %{}) do
        required_fields = @required_fields ++ [:locale, @parent_id_field]
        translation
        |> cast(params, required_fields ++ @optional_fields)
        |> validate_required(required_fields)
        |> foreign_key_constraint(@parent_id_field)
      end

      def translation_query(locale) do
        from t in __MODULE__, where: t.locale == ^locale
      end

      def insert_or_update(repo, parent, parent_params, locale) do
        default_params = %{
          @parent_id_field => parent.id,
          locale: locale
        }

        translation_params = Enum.into @required_fields ++ @optional_fields, default_params, fn(f) ->
          {f, parent_params[to_string(f)]}
        end

        if !Map.get(parent, @assoc) || !Ecto.assoc_loaded?(Map.get(parent, @assoc)) do
          changeset = __MODULE__.changeset(%__MODULE__{}, translation_params)
          repo.insert(changeset)
        else
          changeset = __MODULE__.changeset(Map.get(parent, @assoc), translation_params)
          repo.update(changeset)
        end
      end
    end
  end

  defp config(opts) do
    quote do
      @schema unquote(opts)[:schema] || raise ":schema must be given."
      @belongs_to unquote(opts)[:belongs_to] || raise ":belongs_to must be given."
      @required_fields unquote(opts)[:required_fields] || raise ":required_fields must be given."
      @optional_fields unquote(opts)[:optional_fields] || []
      @assoc unquote(opts)[:assoc] || :translation
    end
  end
end
