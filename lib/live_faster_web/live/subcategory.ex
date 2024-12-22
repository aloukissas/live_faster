defmodule LiveFasterWeb.SubcategoryLive do
  use LiveFasterWeb, :live_view

  alias LiveFaster.Queries

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <%= if @subcategory_product_count > 0 do %>
        <h1 class="mb-2 border-b-2 text-sm font-bold">
          {@subcategory_product_count} {if @subcategory_product_count === 1,
            do: "Product",
            else: "Products"}
        </h1>
      <% else %>
        <p>No products for this subcategory</p>
      <% end %>
      <div class="flex flex-row flex-wrap gap-2">
        <LiveFasterWeb.CustomComponents.product_link
          :for={product <- @subcategory_products}
          product={product}
          category_slug={@category_slug}
          subcategory_slug={product.subcategory_slug}
        />
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(
        %{"category_slug" => category_slug, "subcategory_slug" => subcategory_slug},
        _session,
        socket
      ) do
    subcategory = Queries.get_subcategory_details(subcategory_slug)
    subcategory_product_count = Queries.get_subcategory_product_count(subcategory_slug)
    subcategory_products = Queries.get_products_by_subcategory(subcategory_slug)

    {:ok,
     socket
     |> assign(page_title: "#{subcategory.name} | LiveFaster")
     |> assign(category_slug: category_slug)
     |> assign(subcategory: subcategory)
     |> assign(subcategory_product_count: subcategory_product_count)
     |> assign(subcategory_products: subcategory_products)}
  end
end
