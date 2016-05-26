defmodule MediaSample.Repo.Migrations.ModifyEntryTranslation do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE entry_translations CHANGE content description varchar(255) DEFAULT NULL;"
  end
end
