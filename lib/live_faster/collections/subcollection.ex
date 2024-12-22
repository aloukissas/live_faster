defmodule LiveFaster.Collections.Subcollection do
  use Ecto.Schema

  alias LiveFaster.Categories.{Category, Subcategory}

  @primary_key {:id, :integer, []}

  schema "subcollections" do
    field :name, :string

    belongs_to :category, Category, foreign_key: :category_slug, type: :string, references: :slug
    has_many :subcategories, Subcategory
  end
end
