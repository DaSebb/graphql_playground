defmodule GraphTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GraphTestWeb.Telemetry,
      GraphTest.Repo,
      {DNSCluster, query: Application.get_env(:graph_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GraphTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GraphTest.Finch},
      # Start a worker by calling: GraphTest.Worker.start_link(arg)
      # {GraphTest.Worker, arg},
      # Start to serve requests, typically the last entry
      GraphTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
