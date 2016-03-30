defmodule ForEctoUpgrade.API.V1.Mypage.Entry do
  use Maru.Router
  import Phoenix.View, only: [render: 3]
  alias ForEctoUpgrade.{Repo, Entry, API.EntryView}
  helpers ForEctoUpgrade.API.V1.SharedParams

  plug Guardian.Plug.EnsureAuthenticated, handler: ForEctoUpgrade.API.V1.Session

  resource "/entry" do
    params do
      use [:id]
    end
    get ":id" do
      entry = Entry |> Entry.preload_all |> Repo.get!(params[:id])
      conn |> json(render(EntryView, "show.json", entry: entry))
    end
  end
end
