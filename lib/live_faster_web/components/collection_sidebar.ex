defmodule LiveFasterWeb.CollectionSidebar do
  use LiveFasterWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <aside class="fixed left-0 hidden w-64 min-w-64 max-w-64 overflow-y-auto border-r p-4 md:block">
      <h2 class="border-b border-accent1 text-sm font-semibold text-accent1">
        Choose a Category
      </h2>
      <ul class="flex flex-col items-start justify-center">
        <li :for={collection <- @collections} class="w-full">
          <.link
            patch={~p"/#{collection.slug}"}
            class="block w-full py-1 text-xs text-gray-800 hover:bg-accent2 hover:underline"
          >
            {collection.name}
          </.link>
        </li>
      </ul>
    </aside>
    """
  end

  @impl true
  def mount(socket) do
    collections = LiveFaster.Queries.get_collections()
    {:ok, assign(socket, :collections, collections)}
  end
end
