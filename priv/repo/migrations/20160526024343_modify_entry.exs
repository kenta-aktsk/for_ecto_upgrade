defmodule MediaSample.Repo.Migrations.ModifyEntry do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE entries CHANGE content description varchar(255) DEFAULT NULL;"
  end
end
