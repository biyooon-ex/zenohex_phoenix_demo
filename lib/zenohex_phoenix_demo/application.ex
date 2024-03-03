defmodule ZenohexPhoenixDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    {:ok, session} = Zenohex.open
    key = "demo/example/zenoh-rs-pub"

    children = [
      ZenohexPhoenixDemoWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:zenohex_phoenix_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ZenohexPhoenixDemo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ZenohexPhoenixDemo.Finch},
      # Start a worker by calling: ZenohexPhoenixDemo.Worker.start_link(arg)
      # {ZenohexPhoenixDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      ZenohexPhoenixDemoWeb.Endpoint,
      {ZenohexPhoenixDemo.ZenohexManager, %{session: session, key_expr: key}},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ZenohexPhoenixDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ZenohexPhoenixDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
