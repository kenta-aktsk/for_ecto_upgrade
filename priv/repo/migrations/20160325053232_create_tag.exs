defmodule MediaSample.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags, options: "ROW_FORMAT=DYNAMIC") do
      add :name, :string, null: false
      add :status, :integer, null: false

      timestamps
    end

  end
end
