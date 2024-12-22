defmodule LiveviewFasterWeb.PageController do
  use LiveviewFasterWeb, :controller

  alias LiveviewFaster.Queries

  def home(conn, _params) do
    # TODO: run these in parallel
    collections = Queries.get_collections()
    product_count = Queries.get_product_count()

    conn
    |> put_layout(html: {LiveviewFasterWeb.Layouts, :home})
    |> render(:home, collections: collections, product_count: product_count)
  end

  def category(conn, %{"category_slug" => category_slug}) do
    # TODO: run these in parallel
    # TODO: handle 404
    collections = Queries.get_collections()
    category = Queries.get_category_details(category_slug)
    category_product_count = Queries.get_category_product_count(category_slug)

    conn
    |> put_layout(html: {LiveviewFasterWeb.Layouts, :home})
    |> render(:category,
      collections: collections,
      category: category,
      category_product_count: category_product_count
    )
  end

  def subcategory(conn, %{
        "category_slug" => category_slug,
        "subcategory_slug" => subcategory_slug
      }) do
    # TODO: run these in parallel
    # TODO: handle 404
    collections = Queries.get_collections()
    subcategory = Queries.get_subcategory_details(subcategory_slug)
    subcategory_product_count = Queries.get_subcategory_product_count(subcategory_slug)
    subcategory_products = Queries.get_products_by_subcategory(subcategory_slug)

    conn
    |> put_layout(html: {LiveviewFasterWeb.Layouts, :home})
    |> render(:subcategory,
      collections: collections,
      subcategory: subcategory,
      subcategory_products: subcategory_products,
      subcategory_product_count: subcategory_product_count,
      category_slug: category_slug,
      subcategory_slug: subcategory_slug
    )
  end

  def product(conn, %{
        "product_slug" => product_slug,
        "category_slug" => category_slug,
        "subcategory_slug" => subcategory_slug
      }) do
    # TODO: run these in parallel
    # TODO: handle 404
    collections = Queries.get_collections()
    product = Queries.get_product_details(product_slug)
    related_products = Queries.get_products_by_subcategory(subcategory_slug)
    product_price = product.price |> Decimal.round(2) |> Decimal.to_string()

    conn
    |> put_layout(html: {LiveviewFasterWeb.Layouts, :home})
    |> render(:product,
      collections: collections,
      product: product,
      product_price: product_price,
      related_products: related_products,
      category_slug: category_slug,
      subcategory_slug: subcategory_slug
    )
  end

  def collection(conn, %{"collection_slug" => collection_slug}) do
    # TODO: run these in parallel
    # TODO: handle 404
    collections = Queries.get_collections()
    collections_for_slug = Queries.get_collection_details(collection_slug)

    conn
    |> put_layout(html: {LiveviewFasterWeb.Layouts, :home})
    |> render(:collection, collections: collections, collections_for_slug: collections_for_slug)
  end
end
