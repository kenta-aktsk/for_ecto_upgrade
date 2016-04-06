defmodule MediaSample.API.V1.SharedParams do
  use Maru.Helper

  params :base do
    @one_and_over ~r/^[1-9][0-9]*$/
  end

  params :id do
    use :base
    requires :id, type: :integer, regexp: @one_and_over
  end

  params :auth do
    use :base
    requires :email, type: :string
    requires :password, type: :string
  end

  params :entry do
    use :base
    optional :id, type: :integer, regexp: @one_and_over
    requires :category_id, type: :integer, regexp: @one_and_over
    requires :title, type: :string
    requires :content, type: :string
    optional :image, type: File
    requires :status, type: :integer
    requires :tags, type: List
  end
end
