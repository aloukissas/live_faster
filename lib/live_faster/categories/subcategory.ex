defmodule LiveFaster.Categories.Subcategory do
  use Ecto.Schema

  alias LiveFaster.Products.Product
  alias LiveFaster.Collections.Subcollection

  @primary_key {:slug, :string, [autogenerate: false]}

  schema "subcategories" do
    field :name, :string
    field :image_url, :string

    belongs_to :subcollection, Subcollection
    has_many :products, Product
  end
end
