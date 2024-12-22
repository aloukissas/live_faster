defmodule LiveFasterWeb.CollectionLive do
  use LiveFasterWeb, :live_view

  alias LiveFaster.Queries

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="w-full p-4">
      <h2 class="text-xl font-semibold">{@collection.name}</h2>
      <div class="flex flex-row flex-wrap justify-center gap-2 border-b-2 py-4 sm:justify-start">
        <.link
          :for={category <- @collection.categories}
          class="flex w-[125px] flex-col items-center text-center"
          patch={~p"/products/#{category.slug}"}
        >
          <img
            decoding="sync"
            src={category.image_url || "/placeholder.svg"}
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
    """
  end

  @impl Phoenix.LiveView
  def mount(%{"collection_slug" => collection_slug}, _session, socket) do
    collection = Queries.get_collection_details(collection_slug)

    {:ok,
     socket
     |> assign(page_title: "#{collection.name} | LiveFaster")
     |> assign(collection: collection)}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"collection_slug" => collection_slug}, _uri, socket) do
    collection = Queries.get_collection_details(collection_slug)

    {:noreply,
     socket
     |> assign(page_title: "#{collection.name} | LiveFaster")
     |> assign(collection: collection)}
  end
end
