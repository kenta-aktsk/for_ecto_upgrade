defmodule ForEctoUpgrade.API.V1.SharedParams do
  use Maru.Helper

  params :id do
    requires :id, type: :integer, regexp: ~r/^[1-9][0-9]*$/
  end

  params :auth do
    requires :email, type: :string
    requires :password, type: :string
  end
end
