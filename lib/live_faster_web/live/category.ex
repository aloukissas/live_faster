defmodule LiveFasterWeb.CategoryLive do
  use LiveFasterWeb, :live_view

  alias LiveFaster.Queries

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="container p-4">
      <h1 class="mb-2 border-b-2 text-sm font-bold">
        {@category_product_count} {if @category_product_count == 1, do: "Product", else: "Products"}
      </h1>

      <div class="space-y-4">
        <div :for={subcollection <- @category.subcollections}>
          <h2 class="mb-2 border-b-2 text-lg font-semibold">
            {subcollection.name}
          </h2>
          <div class="flex flex-row flex-wrap gap-2">
            <.link
              :for={subcategory <- subcollection.subcategories}
              class="group flex h-full w-full flex-row gap-2 border px-4 py-2 hover:bg-gray-100 sm:w-[200px]"
              patch={~p"/products/#{@category.slug}/#{subcategory.slug}"}
            >
              <div class="py-2">
                <img
                  loading="eager"
                  decoding="sync"
                  src={subcategory.image_url || "/placeholder.svg"}
                  alt={"A small picture of #{subcategory.name}"}
                  width={48}
                  height={48}
                  quality={65}
                  class="h-12 w-12 flex-shrink-0 object-cover"
                />
              </div>
              <div class="flex h-16 flex-grow flex-col items-start py-2">
                <div class="text-sm font-medium text-gray-700 group-hover:underline">
                  {subcategory.name}
                </div>
              </div>
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(%{"category_slug" => category_slug}, _session, socket) do
    category = Queries.get_category_details(category_slug)
    category_product_count = Queries.get_category_product_count(category_slug)

    {:ok,
     socket
     |> assign(category: category)
     |> assign(category_product_count: category_product_count)}
  end
end
