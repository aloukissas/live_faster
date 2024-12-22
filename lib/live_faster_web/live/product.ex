defmodule LiveFasterWeb.ProductLive do
  use LiveFasterWeb, :live_view

  alias LiveFaster.Queries

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container p-4">
      <h1 class="border-t-2 pt-1 text-xl font-bold text-accent1">
        {@product.name}
      </h1>
      <div class="flex flex-col gap-2">
        <div class="flex flex-row gap-2">
          <img
            loading="eager"
            decoding="sync"
            src={@product.image_url || "/placeholder.svg?height=64&width=64"}
            alt={"A small picture of #{@product.name}"}
            height={256}
            quality={80}
            width={256}
            class="h-56 w-56 flex-shrink-0 border-2 md:h-64 md:w-64"
          />
          <p class="flex-grow text-base">{@product.description}</p>
        </div>
        <p class="text-xl font-bold">
          {@product_price}
        </p>
        <div>add to cart</div>
      </div>
      <div class="pt-8">
        <%= if length(@related_products) > 0 do %>
          <h2 class="text-lg font-bold text-accent1">
            Explore more products
          </h2>
        <% end %>
        <div class="flex flex-row flex-wrap gap-2">
          <div :for={product <- @related_products}>
            <LiveFasterWeb.CustomComponents.product_link
              category_slug={@category_slug}
              subcategory_slug={@product.subcategory_slug}
              product={product}
              imageUrl={product.image_url}
            />
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(
        %{"category_slug" => category_slug, "product_slug" => product_slug},
        _session,
        socket
      ) do
    product = Queries.get_product_details(product_slug)
    related_products = Queries.get_products_by_subcategory(product.subcategory_slug)
    product_price = product.price |> Decimal.round(2) |> Decimal.to_string()

    {:ok,
     socket
     |> assign(product: product)
     |> assign(related_products: related_products)
     |> assign(category_slug: category_slug)
     |> assign(product_price: product_price)}
  end

  @impl true
  def handle_params(%{"product_slug" => product_slug}, _uri, socket) do
    product = Queries.get_product_details(product_slug)
    related_products = Queries.get_products_by_subcategory(product.subcategory_slug)
    product_price = product.price |> Decimal.round(2) |> Decimal.to_string()

    {:noreply,
     socket
     |> assign(product: product)
     |> assign(related_products: related_products)
     |> assign(product_price: product_price)}
  end
end
