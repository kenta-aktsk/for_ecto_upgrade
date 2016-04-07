defmodule MediaSample.Repo.Migrations.ModifyUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :profile, :text
    end

    create index(:users, [:email], unique: true)
  end
end
