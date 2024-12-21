defmodule LiveviewFaster.Categories.Subcategory do
  use Ecto.Schema

  alias LiveviewFaster.Products.Product
  alias LiveviewFaster.Collections.Subcollection

  @primary_key {:slug, :string, [autogenerate: false]}

  schema "subcategories" do
    field :name, :string
    field :image_url, :string

    belongs_to :subcollection, Subcollection
    has_many :products, Product
  end
end
