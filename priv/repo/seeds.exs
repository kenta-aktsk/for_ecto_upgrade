# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MediaSample.Repo.insert!(%MediaSample.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MediaSample.{Repo, AdminUser, User, Category, Tag, Enums.UserType, Enums.Status}

password = "1234"
params = %{email: "admin01@example.com", name: "Admin01", password: password, password_confirmation: password, status: Status.valid.id}
changeset = AdminUser.changeset(%AdminUser{}, params)
Repo.insert!(changeset)

password = "12345678"
params = %{email: "user01@example.com", name: "User01", profile: "Profile of User01", password: password, password_confirmation: password, user_type: UserType.editor.id, status: Status.valid.id}
changeset = User.changeset(%User{}, params)
Repo.insert!(changeset)

params = %{name: "entertainment", description: "description of entertainment", status: Status.valid.id}
changeset = Category.changeset(%Category{}, params)
Repo.insert!(changeset)

params = %{name: "economy", description: "description of economy", status: Status.valid.id}
changeset = Category.changeset(%Category{}, params)
Repo.insert!(changeset)

params = %{name: "travel", status: Status.valid.id}
changeset = Tag.changeset(%Tag{}, params)
Repo.insert!(changeset)

params = %{name: "shopping", status: Status.valid.id}
changeset = Tag.changeset(%Tag{}, params)
Repo.insert!(changeset)
