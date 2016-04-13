defmodule MediaSample.Repo.Migrations.AddUserConfirmationTokenIndex do
  use Ecto.Migration

  def change do
    create index(:users, [:confirmation_token], unique: true)
  end
end
