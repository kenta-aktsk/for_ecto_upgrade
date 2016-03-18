defmodule ForEctoUpgrade.UserModelPasswordConcern do
  defmacro __using__(opts) do
    quote location: :keep do
      alias Ecto.Changeset
      unquote(config(opts))

      def adjust_validation_fields(%{__struct__: _} = user, required_fields, optional_fields)
        when is_list(required_fields) and is_list(optional_fields) do
        if for_insert?(user) do
          {append_password_fields(required_fields), optional_fields}
        else
          {required_fields, append_password_fields(optional_fields)}
        end
      end

      def check_password(%Changeset{data: data, params: %{"password" => password, "password_confirmation" => password_confirmation}} = changeset) do
        if for_update?(data) && !password && !password_confirmation do
          changeset
        else
          changeset
          |> validate_length(:password, min: @min_password_length, max: @max_password_length)
          |> validate_confirmation(:password)
          |> put_encrypted_password
        end
      end
      def check_password(changeset), do: changeset

      def put_encrypted_password(%Changeset{params: %{"password" => password}} = changeset) do
        if password, do: put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password)), else: changeset
      end

      def append_password_fields(fields) when is_list(fields) do
        fields ++ [:password, :password_confirmation]
      end

      defoverridable [adjust_validation_fields: 3, check_password: 1]
    end
  end

  defp config(opts) do
    quote do
      @min_password_length unquote(opts)[:min_password_length] || raise ":min_password_length must be given."
      @max_password_length unquote(opts)[:max_password_length] || raise ":min_password_length must be given."
    end
  end
end
