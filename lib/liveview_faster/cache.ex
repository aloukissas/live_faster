defmodule LiveviewFaster.Cache do
  @moduledoc false

  use Nebulex.Cache,
    otp_app: :liveview_faster,
    adapter: Nebulex.Adapters.Local
end
