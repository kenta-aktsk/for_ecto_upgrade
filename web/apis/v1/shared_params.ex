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

  params :page do
    use :base
    optional :page, type: :integer, regexp: @one_and_over
  end

  params :entry do
    use :base
    optional :id, type: :integer, regexp: @one_and_over
    requires :category_id, type: :integer, regexp: @one_and_over
    requires :title, type: :string
    requires :description, type: :string
    optional :image, type: :string
    requires :status, type: :integer
    requires :tags, type: List
    optional :sections, type: List
  end

  params :search do
    use :base
    requires :words, type: :string
  end
end
