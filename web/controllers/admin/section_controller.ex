defmodule MediaSample.Admin.SectionController do
  use MediaSample.Web, :admin_controller
  use MediaSample.LocalizedController
  alias MediaSample.{SectionService, Section}

  plug :scrub_params, "section" when action in [:create, :update]

  def index(conn, params, locale) do
    page = Section |> Section.preload_all(locale) |> Repo.slave.paginate(params)
    render(conn, "index.html", sections: page.entries, page: page)
  end

  def new(conn, _params, _locale) do
    changeset = Section.changeset(%Section{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"section" => section_params}, locale) do
    changeset = Section.changeset(%Section{}, section_params)

    case Repo.transaction(SectionService.insert(changeset, section_params, locale)) do
      {:ok, %{section: section, upload: _upload}} ->
        conn
        |> put_flash(:info, gettext("%{name} created successfully.", name: gettext("Section")))
        |> redirect(to: admin_section_path(conn, :show, locale, section)) |> halt
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} create failed.", name: gettext("Section")))
        |> render("new.html", changeset: extract_changeset(failed_value, changeset))
    end
  end

  def show(conn, %{"id" => id}, locale) do
    section = Section |> Section.preload_all(locale) |> Repo.slave.get!(id)
    render(conn, "show.html", section: section)
  end

  def edit(conn, %{"id" => id}, locale) do
    section = Section |> Section.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Section.changeset(section)
    render(conn, "edit.html", section: section, changeset: changeset)
  end

  def update(conn, %{"id" => id, "section" => section_params}, locale) do
    section = Section |> Section.preload_all(locale) |> Repo.slave.get!(id)
    changeset = Section.changeset(section, section_params)

    case Repo.transaction(SectionService.update(changeset, section_params, locale)) do
      {:ok, %{section: section, upload: _upload}} ->
        conn
        |> put_flash(:info, gettext("%{name} updated successfully.", name: gettext("Section")))
        |> redirect(to: admin_section_path(conn, :show, locale, section)) |> halt
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} update failed.", name: gettext("Section")))
        |> render("edit.html", section: section, changeset: extract_changeset(failed_value, changeset))
    end
  end

  def delete(conn, %{"id" => id}, locale) do
    section = Repo.slave.get!(Section, id)

    case Repo.transaction(SectionService.delete(section)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("%{name} deleted successfully.", name: gettext("Section")))
        |> redirect(to: admin_section_path(conn, :index, locale)) |> halt
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> put_flash(:error, gettext("%{name} delete failed.", name: gettext("Section")))
        |> redirect(to: admin_section_path(conn, :index, locale)) |> halt
    end
  end
end
