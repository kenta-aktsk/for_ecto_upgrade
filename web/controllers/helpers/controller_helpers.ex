defmodule MediaSample.ControllerHelpers do
  def extract_changeset(%Ecto.Changeset{} = failed_value, _), do: failed_value
  def extract_changeset(_, %Ecto.Changeset{} = changeset), do: changeset
end
