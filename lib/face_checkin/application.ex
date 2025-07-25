defmodule FaceCheckin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FaceCheckinWeb.Telemetry,
      FaceCheckin.Repo,
      {DNSCluster, query: Application.get_env(:face_checkin, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FaceCheckin.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FaceCheckin.Finch},
      # Start a worker by calling: FaceCheckin.Worker.start_link(arg)
      # {FaceCheckin.Worker, arg},
      # Start to serve requests, typically the last entry
      FaceCheckinWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FaceCheckin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FaceCheckinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
