defmodule LiveFasterWeb.HomeLive do
  use LiveFasterWeb, :live_view

  alias LiveFaster.Queries

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="w-full p-4">
      <div class="mb-2 w-full flex-grow border-b-[1px] border-accent1 text-sm font-semibold text-black">
        Explore {@product_count} products
      </div>
      <div :for={collection <- @collections}>
        <h2 class="text-xl font-semibold">{collection.name}</h2>
        <div class="flex flex-row flex-wrap justify-center gap-2 border-b-2 py-4 sm:justify-start">
          <.link
            :for={category <- collection.categories}
            class="flex w-[125px] flex-col items-center text-center"
            patch={~p"/products/#{category.slug}"}
          >
            <img
              loading="lazy"
              decoding="sync"
              src={"#{category.image_url}?w=96&amp;q=65" || "/placeholder.svg"}
              alt={"A small picture of #{category.name}"}
              class="mb-2 h-14 w-14 border hover:bg-accent2"
              width={48}
              height={48}
              quality={65}
            />
            <span class="text-xs">{category.name}</span>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    product_count = Queries.get_product_count()
    collections = Queries.get_collections()

    {:ok,
     socket
     |> assign(:product_count, product_count)
     |> assign(:collections, collections)}
  end
end
