defmodule DockerApi do
  use Application
  require Logger

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
