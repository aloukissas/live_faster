defmodule LiveFaster.Collections.Collection do
  use Ecto.Schema

  alias LiveFaster.Categories.Category

  @primary_key {:id, :integer, []}
  @type t :: %__MODULE__{}

  schema "collections" do
    field :name, :string
    field :slug, :string

    has_many :categories, Category
  end
end
