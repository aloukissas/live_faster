defmodule LiveviewFaster.Products.Product do
  use Ecto.Schema

  @primary_key {:slug, :string, [autogenerate: false]}
  @type t :: %__MODULE__{}

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :image_url, :string

    belongs_to :subcategory, LiveviewFaster.Categories.Subcategory,
      foreign_key: :subcategory_slug,
      type: :string,
      references: :slug
  end
end
