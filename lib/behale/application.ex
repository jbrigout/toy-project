defmodule Behale.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BehaleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Behale.PubSub},
      # Start the Endpoint (http/https)
      BehaleWeb.Endpoint,
      # Start a worker by calling: Behale.Worker.start_link(arg)
      # {Behale.Worker, arg}
      Behale.DatabaseServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Behale.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BehaleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
