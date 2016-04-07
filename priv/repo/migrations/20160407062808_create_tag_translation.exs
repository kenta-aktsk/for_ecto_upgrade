defmodule MediaSample.Repo.Migrations.CreateTagTranslation do
  use Ecto.Migration

  def change do
    create table(:tag_translations, options: "ROW_FORMAT=DYNAMIC") do
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
      add :locale, :string, null: false
      add :name, :string, null: false

      timestamps
    end

    create index(:tag_translations, [:tag_id, :locale], unique: true)
  end
end
