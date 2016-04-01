defmodule ForEctoUpgrade.Repo do
  use Ecto.Repo, otp_app: :for_ecto_upgrade
  use ForEctoUpgrade.ReadRepo
end
