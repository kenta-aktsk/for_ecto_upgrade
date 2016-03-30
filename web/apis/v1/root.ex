defmodule ForEctoUpgrade.API.V1.Root do
  use Maru.Router
  mount ForEctoUpgrade.API.V1.Mypage.Root
  mount ForEctoUpgrade.API.V1.Session
end
