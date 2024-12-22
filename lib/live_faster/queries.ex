defmodule LiveFaster.Queries do
  use Nebulex.Caching

  import Ecto.Query, only: [from: 2]

  alias LiveFaster.Repo
  alias LiveFaster.Cache
  alias LiveFaster.Categories.{Category, Subcategory}
  alias LiveFaster.Collections.{Collection, Subcollection}
  alias LiveFaster.Products.Product

  @cache_ttl :timer.hours(2)

  @doc """
  Get all collections, preloaded with categories.

  Returns a list of `Collection` structs, ordered by the `Collection.name` field.
  """
  @spec get_collections() :: list(Collection.t())
  @decorate cacheable(cache: Cache, key: {__MODULE__, :get_collections}, opts: [ttl: @cache_ttl])
  def get_collections do
    from(c in Collection,
      preload: [:categories],
      order_by: [asc: c.name]
    )
    |> Repo.all()
  end

  @doc """
  Get all products by subcategory.

  Returns a list of `Product` structs, ordered by the `Product.slug` field.
  """
  @spec get_products_by_subcategory(subcategory_slug :: String.t()) :: list(Product.t())
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_products_by_subcategory, subcategory_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_products_by_subcategory(subcategory_slug) do
    from(p in Product,
      where: p.subcategory_slug == ^subcategory_slug,
      order_by: [asc: :slug]
    )
    |> Repo.all()
  end

  @doc """
  Get product details by slug.

  Returns a `Product` struct.
  """
  @spec get_product_details(product_slug :: String.t()) :: Product.t() | nil
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_product_details, product_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_product_details(product_slug) do
    Repo.get_by(Product, slug: product_slug)
  end

  @doc """
  Get category details by slug.

  Returns a list of `Category` structs, preloaded with collections and their subcategories.
  """
  @spec get_category_details(category_slug :: String.t()) :: list(Category.t())
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_category_details, category_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_category_details(category_slug) do
    from(c in Category,
      where: c.slug == ^category_slug,
      preload: [subcollections: :subcategories],
      order_by: [asc: c.slug]
    )
    |> Repo.one()
  end

  @doc """
  Get collection details by slug.

  Returns a `Collection` struct, preloaded with categories.
  """
  @spec get_collection_details(collection_slug :: String.t()) :: Collection.t() | nil
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_collection_details, collection_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_collection_details(collection_slug) do
    from(c in Collection,
      where: c.slug == ^collection_slug,
      preload: [:categories],
      order_by: [asc: :slug]
    )
    |> Repo.one()
  end

  @doc """
  Get the total number of products.
  """
  @spec get_product_count() :: non_neg_integer()
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_product_count},
              opts: [ttl: @cache_ttl]
            )
  def get_product_count do
    Repo.aggregate(Product, :count)
  end

  @doc """
  Get the total number of products in a category.
  """
  @spec get_category_product_count(category_slug :: String.t()) :: non_neg_integer()
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_category_product_count, category_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_category_product_count(category_slug) do
    from(c in Category,
      where: c.slug == ^category_slug,
      left_join: sc in assoc(c, :subcollections),
      left_join: scat in assoc(sc, :subcategories),
      left_join: p in assoc(scat, :products),
      select: count(p.slug)
    )
    |> Repo.one()
  end

  @doc """
  Get subcategory details by slug.
  """
  @spec get_subcategory_details(subcategory_slug :: String.t()) :: Subcategory.t() | nil
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_subcategory_details, subcategory_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_subcategory_details(subcategory_slug) do
    Repo.get_by(Subcategory, slug: subcategory_slug)
  end

  @doc """
  Get the total number of products in a subcategory.
  """
  @spec get_subcategory_product_count(subcategory_slug :: String.t()) :: non_neg_integer()
  @decorate cacheable(
              cache: Cache,
              key: {__MODULE__, :get_subcategory_product_count, subcategory_slug},
              opts: [ttl: @cache_ttl]
            )
  def get_subcategory_product_count(subcategory_slug) do
    from(p in Product,
      where: p.subcategory_slug == ^subcategory_slug,
      select: count(p.slug)
    )
    |> Repo.one()
  end

  @doc """
  Search for products by name, using a hybrid search pattern.
  For short search terms (<=2 chars), uses ILIKE prefix matching.
  For longer terms, uses full-text search with tsquery.

  Returns a list of products with their associated subcategories, subcollections and categories.
  """
  @spec search_products(search_term :: String.t()) :: [Product.t()]
  def search_products(search_term) do
    # TODO: add cache for 2 hours
    if String.length(search_term) <= 2 do
      # Use ILIKE for prefix matching on short terms
      from(p in Product,
        inner_join: sc in Subcategory,
        on: p.subcategory_slug == sc.slug,
        inner_join: scol in Subcollection,
        on: sc.subcollection_id == scol.id,
        inner_join: c in Category,
        on: scol.category_slug == c.slug,
        where: fragment("? ILIKE ?", p.name, ^"#{search_term}%"),
        limit: 5,
        preload: [subcategory: {sc, subcollection: {scol, category: c}}]
      )
    else
      # Use full-text search for longer terms
      formatted_search_term =
        search_term
        |> String.split(" ")
        |> Enum.filter(&(String.trim(&1) != ""))
        |> Enum.map(&"#{&1}:*")
        |> Enum.join(" & ")

      from(p in Product,
        inner_join: sc in Subcategory,
        on: p.subcategory_slug == sc.slug,
        inner_join: scol in Subcollection,
        on: sc.subcollection_id == scol.id,
        inner_join: c in Category,
        on: scol.category_slug == c.slug,
        where:
          fragment(
            "to_tsvector('english', ?) @@ to_tsquery('english', ?)",
            p.name,
            ^formatted_search_term
          ),
        limit: 5,
        preload: [subcategory: {sc, subcollection: {scol, category: c}}]
      )
    end
    |> Repo.all()
  end
end
