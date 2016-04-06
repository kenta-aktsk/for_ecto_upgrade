defmodule MediaSample.API.V1.Mypage.Root do
  use Maru.Router
  resource "/mypage" do
    mount MediaSample.API.V1.Mypage.Entry
  end
end
