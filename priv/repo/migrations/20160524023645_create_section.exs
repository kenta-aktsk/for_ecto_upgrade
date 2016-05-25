defmodule MediaSample.Repo.Migrations.CreateSection do
  use Ecto.Migration

  def change do
    create table(:sections, options: "ROW_FORMAT=DYNAMIC") do
      add :entry_id, references(:entries, on_delete: :delete_all), null: false
      add :section_type, :integer, null: false
      add :content, :text
      add :image, :string
      add :seq, :integer, null: false
      add :status, :integer, null: false

      timestamps
    end
  end
end
