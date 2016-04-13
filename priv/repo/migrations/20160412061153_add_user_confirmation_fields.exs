defmodule MediaSample.Repo.Migrations.AddUserConfirmationFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmation_token, :string
      add :confirmed_at, :datetime
      add :confirmation_sent_at, :datetime
    end
  end
end
