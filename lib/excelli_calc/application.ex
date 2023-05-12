defmodule ExcelliCalc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExcelliCalcWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExcelliCalc.PubSub},
      # Start Finch
      {Finch, name: ExcelliCalc.Finch},
      # Start the Endpoint (http/https)
      ExcelliCalcWeb.Endpoint,
      # Start a worker by calling: ExcelliCalc.Worker.start_link(arg)
      # {ExcelliCalc.Worker, arg}
      {Xandra, name: :xandra_connection, nodes: ["127.0.0.1:9042"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExcelliCalc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExcelliCalcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
