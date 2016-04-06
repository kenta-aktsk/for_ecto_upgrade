defmodule MediaSample.API.V2.Root do
  use Maru.Router
  mount MediaSample.API.V2.Homepage
end
