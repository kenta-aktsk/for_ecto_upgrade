defmodule MediaSample.Repo.Migrations.CreateSectionTranslation do
  use Ecto.Migration

  def change do
    create table(:section_translations, options: "ROW_FORMAT=DYNAMIC") do
      add :section_id, references(:sections, on_delete: :delete_all), null: false
      add :locale, :string, null: false
      add :content, :text

      timestamps
    end
  end
end
