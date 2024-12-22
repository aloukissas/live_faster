defmodule LiveFaster.Repo do
  use Ecto.Repo,
    otp_app: :live_faster,
    adapter: Ecto.Adapters.Postgres
end
