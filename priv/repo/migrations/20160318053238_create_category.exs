defmodule MediaSample.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories, options: "ROW_FORMAT=DYNAMIC") do
      add :name, :string
      add :description, :text
      add :image, :string
      add :status, :integer

      timestamps
    end

  end
end
