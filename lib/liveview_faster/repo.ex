defmodule LiveviewFaster.Repo do
  use Ecto.Repo,
    otp_app: :liveview_faster,
    adapter: Ecto.Adapters.Postgres
end
