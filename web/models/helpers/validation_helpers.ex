defmodule MediaSample.ValidationHelpers do
  alias Ecto.Changeset

  def validate_email_format(%Changeset{} = changeset, field) when is_atom(field) do
    Changeset.validate_format(changeset, field, ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end
end
