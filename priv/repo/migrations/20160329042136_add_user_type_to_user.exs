defmodule ForEctoUpgrade.Repo.Migrations.AddUserTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :user_type, :integer, null: false, default: ForEctoUpgrade.Enums.UserType.reader.id
    end
  end
end
