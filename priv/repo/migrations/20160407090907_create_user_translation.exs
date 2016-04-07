defmodule MediaSample.Repo.Migrations.CreateUserTranslation do
  use Ecto.Migration

  def change do
    create table(:user_translations, options: "ROW_FORMAT=DYNAMIC") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :locale, :string, null: false
      add :name, :string, null: false
      add :profile, :text

      timestamps
    end

    create index(:user_translations, [:user_id, :locale], unique: true)
  end
end
