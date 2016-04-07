defmodule MediaSample.Helpers do
  import Plug.Conn, only: [get_session: 2]
  alias MediaSample.{Repo, Gettext, Util}
  def user_logged_in?(conn) do
    case current_user(conn) do
      nil -> false
      _ -> true
    end
  end

  def current_user(conn) do
    get_session(conn, :current_user)
  end

  def current_locale(conn) do
    if Map.has_key?(conn.assigns, :locale) do
      conn.assigns.locale
    else
      Gettext.config[:default_locale]
    end
  end

  def valid_collection(module, caption_field, locale \\ nil) when is_atom(module) and is_atom(caption_field) do
    module
    |> module.valid
    |> Util.pipe_if(locale, &(&1 |> module.preload_all(locale)))
    |> Repo.slave.all
    |> Enum.map(&({translate(&1, caption_field), &1.id}))
  end

  def assoc_captions(association, field) do
    if Ecto.assoc_loaded?(association) do
      association |> Enum.map(&translate(&1, field)) |> Enum.join(", ")
    else
      []
    end
  end

  def assoc_ids(association) do
    if Ecto.assoc_loaded?(association) do
      association |> Enum.map(&(&1.id))
    else
      []
    end
  end

  def translate(nil, field), do: ""
  def translate(model, field) do
    if Map.has_key?(model, :translation) && !is_nil(model.translation) &&
       Ecto.assoc_loaded?(model.translation) && Map.has_key?(model.translation, field) do
      Map.get(model.translation, field)
    else
      Map.get(model, field)
    end
  end
end
