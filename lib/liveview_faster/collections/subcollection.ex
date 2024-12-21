defmodule LiveviewFaster.Collections.Subcollection do
  use Ecto.Schema

  @primary_key {:id, :integer, []}

  schema "subcollections" do
    field :name, :string

    belongs_to :category, LiveviewFaster.Categories.Category, foreign_key: :category_slug
    has_many :subcategories, LiveviewFaster.Categories.Subcategory
  end
end
