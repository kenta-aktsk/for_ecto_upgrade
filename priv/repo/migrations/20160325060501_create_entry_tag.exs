defmodule MediaSample.Repo.Migrations.CreateEntryTag do
  use Ecto.Migration

  def change do
    create table(:entry_tags, options: "ROW_FORMAT=DYNAMIC") do
      add :entry_id, references(:entries)
      add :tag_id, references(:tags)
    end

  end
end
