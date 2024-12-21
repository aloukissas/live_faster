defmodule LiveviewFaster.Collections.Collection do
  use Ecto.Schema

  @primary_key {:id, :integer, []}
  @type t :: %__MODULE__{}

  schema "collections" do
    field :name, :string
    field :slug, :string

    has_many :categories, LiveviewFaster.Categories.Category
  end
end
