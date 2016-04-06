defmodule MediaSample.Repo.Migrations.CreateEntry do
  use Ecto.Migration

  def change do
    create table(:entries, options: "ROW_FORMAT=DYNAMIC") do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :content, :text, null: false
      add :image, :string
      add :status, :integer, null: false

      timestamps
    end

  end
end
