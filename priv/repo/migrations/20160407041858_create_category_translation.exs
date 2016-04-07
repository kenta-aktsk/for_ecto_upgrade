defmodule MediaSample.Repo.Migrations.CreateCategoryTranslation do
  use Ecto.Migration

  def change do
    create table(:category_translations, options: "ROW_FORMAT=DYNAMIC") do
      add :category_id, references(:categories, on_delete: :delete_all), null: false
      add :locale, :string, null: false
      add :name, :string, null: false
      add :description, :text, null: false

      timestamps
    end

    create index(:category_translations, [:category_id, :locale], unique: true)
  end
end
