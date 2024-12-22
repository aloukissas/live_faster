defmodule LiveFaster.Cache do
  @moduledoc false

  use Nebulex.Cache,
    otp_app: :live_faster,
    adapter: Nebulex.Adapters.Local
end
