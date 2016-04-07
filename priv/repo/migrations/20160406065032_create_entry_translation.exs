defmodule MediaSample.Repo.Migrations.CreateEntryTranslation do
  use Ecto.Migration

  def change do
    create table(:entry_translations, options: "ROW_FORMAT=DYNAMIC") do
      add :entry_id, references(:entries, on_delete: :delete_all), null: false
      add :locale, :string, null: false
      add :title, :string, null: false
      add :content, :text, null: false

      timestamps
    end

  end
end
