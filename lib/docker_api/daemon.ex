defmodule DockerApi.Daemon do
  require Logger

  def connect() do
    HTTPoison.get("unix:///var/run/docker.sock")
  end



end
