defmodule LiveviewFasterWeb.ProductLink do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <a
      prefetch={true}
      class="group flex h-[130px] w-full flex-row border px-4 py-2 hover:bg-gray-100 sm:w-[250px]"
      href={"/products/#{@category_slug}/#{@subcategory_slug}/#{@product.slug}"}
    >
      <div class="py-2">
        <img
          decoding="sync"
          src={@image_url || "/placeholder.svg?height=48&width=48"}
          alt="A small picture of {@product.name}"
          width={48}
          height={48}
          quality={65}
          class="h-auto w-12 flex-shrink-0 object-cover"
        />
      </div>
      <div class="px-2" />
      <div class="h-26 flex flex-grow flex-col items-start py-2">
        <div class="text-sm font-medium text-gray-700 group-hover:underline">
          {@product.name}
        </div>
        <p class="overflow-hidden text-xs">{@product.description}</p>
      </div>
    </a>
    """
  end
end
