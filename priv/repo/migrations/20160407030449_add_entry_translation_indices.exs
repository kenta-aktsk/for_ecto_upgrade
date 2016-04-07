defmodule MediaSample.Repo.Migrations.AddEntryTranslationIndices do
  use Ecto.Migration

  def change do
    create index(:entry_translations, [:entry_id, :locale], unique: true)
  end
end
