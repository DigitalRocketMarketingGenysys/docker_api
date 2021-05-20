defmodule DockerApi do
  use Application
  require Logger
  @moduledoc """
  Application to interface with the Docker Engine API, either through unix or tcp
  """

  @doc """
  Starts the DockerApi Application setting the application environment that will be used to interface with the Docker Engine.
  <br>Note: if not set, application will not start.

      iex> DockerApi.start("127.0.0.1", :tcp)
        {:ok, pid}

      iex> DockerApi.start("/var/run/docker.sock", :unix)
        {:ok, pid}
  """
  def start(host, method) do
    Logger.warn "Starting Elixir Docker API"
    {:ok, _} = Application.ensure_all_started(:httpoison)
    case setup(host, method) do
    :ok -> {:ok, self()}
    :error -> {:error, "Could not start Elixir Docker API"}
    _-> {:error, "Could not start Elixir Docker API"}
    end


  end

  defp setup(host, :unix) do
    Logger.warn "Setting the Docker Engine API to use Unix"
    Application.put_env(:docker_api, :host, %{host: host, method: :unix}, [persistent: :true])
  end

  defp setup(host, :tcp) do
    Logger.warn "Setting the Docker Engine API to use TCP"
    Application.put_env(:docker_api, :host, %{host: host, method: :tcp}, [persistent: :true])

  end
end
