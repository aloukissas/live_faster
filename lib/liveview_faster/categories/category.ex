defmodule LiveviewFaster.Categories.Category do
  use Ecto.Schema

  @primary_key {:id, :integer, []}
  @type t :: %__MODULE__{}

  schema "categories" do
    field :slug, :string
    field :name, :string
    field :image_url, :string

    belongs_to :collection, LiveviewFaster.Collections.Collection
  end
end
