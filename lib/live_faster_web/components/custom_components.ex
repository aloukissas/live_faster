defmodule LiveFasterWeb.CustomComponents do
  use LiveFasterWeb, :html

  def product_link(assigns) do
    ~H"""
    <.link
      class="group flex h-[130px] w-full flex-row border px-4 py-2 hover:bg-gray-100 sm:w-[250px]"
      patch={~p"/products/#{@category_slug}/#{@subcategory_slug}/#{@product.slug}"}
    >
      <div class="py-2">
        <img
          loading="eager"
          decoding="sync"
          srcset={"#{@product.image_url}?w=48&amp;q=65 1x, #{@product.image_url}?w=96&amp;q=65 2x"}
          src={"#{@product.image_url}?w=96&amp;q=65" || "/placeholder.svg"}
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
    </.link>
    """
  end
end
