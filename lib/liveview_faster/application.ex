defmodule LiveviewFaster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveviewFasterWeb.Telemetry,
      LiveviewFaster.Repo,
      {DNSCluster, query: Application.get_env(:liveview_faster, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveviewFaster.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveviewFaster.Finch},
      # Start a worker by calling: LiveviewFaster.Worker.start_link(arg)
      # {LiveviewFaster.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveviewFasterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveviewFaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveviewFasterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
