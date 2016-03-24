defmodule ForEctoUpgrade.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, options: "ROW_FORMAT=DYNAMIC") do
      add :email, :string
      add :name, :string
      add :encrypted_password, :string
      add :profile, :string
      add :image, :string
      add :status, :integer

      timestamps
    end

  end
end
