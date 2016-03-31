defmodule ForEctoUpgrade.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias ForEctoUpgrade.{Repo, User}

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, User |> User.valid |> Repo.get(String.to_integer(id))}
  def from_token(_), do: {:error, "Unknown resource type"}
end
