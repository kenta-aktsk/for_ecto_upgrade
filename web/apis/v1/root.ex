defmodule MediaSample.API.V1.Root do
  use Maru.Router
  mount MediaSample.API.V1.Mypage.Root
  mount MediaSample.API.V1.Session
end
