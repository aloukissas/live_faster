defmodule LiveviewFaster.Collections.Subcollection do
  use Ecto.Schema

  alias LiveviewFaster.Categories.{Category, Subcategory}

  @primary_key {:id, :integer, []}

  schema "subcollections" do
    field :name, :string

    belongs_to :category, Category, foreign_key: :category_slug, type: :string
    has_many :subcategories, Subcategory
  end
end
