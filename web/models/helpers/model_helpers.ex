defmodule MediaSample.ModelHelpers do
  def for_insert?(%{__struct__: _} = model) do
    model.__meta__.state == :built
  end

  def for_update?(%{__struct__: _} = model) do
    model.__meta__.state == :loaded
  end

  def delete_param(%Ecto.Changeset{} = changeset, key) when is_binary(key) do
    update_in changeset.params, &Map.delete(&1, key)
  end
end
