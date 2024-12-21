defmodule LiveviewFaster.Categories.Category do
  use Ecto.Schema

  alias LiveviewFaster.Collections.{Collection, Subcollection}

  @primary_key {:slug, :string, [autogenerate: false]}
  @type t :: %__MODULE__{}

  schema "categories" do
    field :name, :string
    field :image_url, :string

    belongs_to :collection, Collection
    has_many :subcollections, Subcollection
  end
end
