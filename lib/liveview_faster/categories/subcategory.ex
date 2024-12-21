defmodule LiveviewFaster.Categories.Subcategory do
  use Ecto.Schema

  @primary_key {:slug, :string, [autogenerate: false]}

  schema "subcategories" do
    field :name, :string
    field :image_url, :string

    belongs_to :subcollection, LiveviewFaster.Collections.Subcollection
    has_many :products, LiveviewFaster.Products.Product
  end
end
