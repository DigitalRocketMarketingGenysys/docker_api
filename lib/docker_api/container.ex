defmodule DockerApi.Container do
  require Logger
  import DockerApi.HTTP, only: :functions
  alias DockerApi.HTTP


  @doc """
  Fetch all the containers from a given docker host

  host: "127.0.0.1"

     iex> DockerApi.Container.all("127.0.0.1")
        [%{...}, ..]
  """
  def all(host) when is_binary(host) do
    Logger.warn "API: Getting all docker containers"
    response = HTTP.get(host <> "/containers/json", %{all: 1})
    handle_response(response)
  end

  def all() do
    Logger.warn "API: Getting all docker containers using preconfigured host"
    response = HTTP.get("/containers/json", %{all: 1})
    handle_response(response)
  end

  @doc """
  Fetch all the containers from a given docker host

  host: "127.0.0.1"
  opts: %{}

  * See docker API documentation for full list of query parameters

      iex> DockerApi.Container.all("127.0.0.1", %{all: 1})
        [%{...}, ..]
  """
  def all(host, opts) when is_map(opts) do

    response = HTTP.get(host <> "/containers/json", opts)
    handle_response(response)
  end

  @doc """
  Find a container when hosts is a List

  hosts: ["127.0.0.1", 10.10.100.31"]
  id: "1234567"

      iex> DockerApi.Container.find(["127.0.0.1", 10.10.100.31"], "123456")
        %{...}
  """
  def find(hosts, id) when is_list(hosts), do: _find(hosts, id, %{})

  @doc """
  Find a container when hosts is a String

  hosts: "127.0.0.1"
  id: "1234567"

      iex> DockerApi.Container.find("127.0.0.1", "123456")
        %{...}
  """
  def find(host, id) when is_binary(host) do
    response = HTTP.get(host <> "/containers/#{id}/json")
    handle_response(response)
  end

  def find_by(query) do
    Logger.warn "Finding Container of #{query}"
    response = HTTP.get("/containers/json?all=true;filters={#{query}}")
    handle_response(response)
  end

  def find(container_id) when is_binary(container_id) do
    Logger.warn "Finding Container"
    response = HTTP.get("/containers/#{container_id}/json")
    handle_response(response)
  end

  defp _find([], _id, result), do: result

  defp _find([head | tail], id, _result) do
    case find(head, id) do
      {:ok, body, 200} when is_map(body) ->
        _find([], id, {:ok, body, 200})
      {result, body, code} ->
        _find(tail, id, {result, body, code})
    end
  end

  @doc """
  Top running processes inside the container

  """
  def top(host, id) do
    response = HTTP.get(host <> "/containers/#{id}/top")
    handle_response(response)
  end

  def changes(host, id) do
    response = HTTP.get(host <> "/containers/#{id}/changes")
    handle_response(response)
  end

  def start(id) do
    response = HTTP.post("/containers/#{id}/start")
    handle_response(response)
  end

  def update(id, params) do
    Logger.warn "Updating the container"
    response = HTTP.post("/containers/#{id}/update", params)
    handle_response(response)
  end

  def rename(id, name) do
    Logger.warn "Updating the container"
    response = HTTP.post("/containers/#{id}/rename?name=#{name}")
    handle_response(response)
  end

  def start(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/start")
    handle_response(response)
  end

  def start(host, id, opts) do
    response = HTTP.post(host <> "/containers/#{id}/start", opts)
    handle_response(response)
  end

  def delete(host, id) do
    response = HTTP.delete(host <> "/containers/#{id}")
    handle_response(response)
  end

  @doc """
  Delete a container

  host: "127.0.0.1"
  id: "123456"
  otps: %{}
  """
  def delete(host, id, opts) do
    response = HTTP.delete(host <> "/containers/#{id}", opts)
    handle_response(response)
  end


  def stop(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/stop")
    handle_response(response)
  end

  def stop(id) do
    response = HTTP.post("/containers/#{id}/stop")
    handle_response(response)
  end

  def wait(id, condition) do
    response = HTTP.post("/containers/#{id}/wait?condition=#{condition}")
    handle_response(response)
  end

  def restart(id) do
    Logger.warn "Debugging Restart #1"
    host = Application.get_env(:docker_api, :host)
    response = HTTP.post("/containers/#{id}/restart")
    handle_response(response)
  end

  def create(name, opts) do
    Logger.warn "Debugging container create"
    IO.inspect opts
    response = HTTP.post("/containers/create?name=#{name}", opts) |> IO.inspect
    handle_response(response)
  end

  def restart(host, id) do
    Logger.warn "Debugging Restart #2"
    response = HTTP.post("/var/run/docker.sock/containers/#{id}/restart")
    handle_response(response)
  end

  def kill(host, id) do
    response = HTTP.post(host <> "/containers/#{id}/kill")
    handle_response(response)
  end

  def exec(host, id, opts) do
    response = HTTP.post(host <> "/containers/#{id}/exec", opts)
    handle_response(response)
  end

  def exec_start(host, id, opts) do
    {:ok, %HTTPoison.AsyncResponse{id: _id}} = HTTPoison.post host <> "/exec/#{id}/start?stream=0", Poison.encode!(opts), %{"content-type" => "application/json"}, stream_to: self()
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  def exec_start(id, opts) do
    {:ok, %HTTPoison.AsyncResponse{id: _id}} = HTTPoison.post "/exec/#{id}/start?stream=0", Poison.encode!(opts), %{"content-type" => "application/json"}, stream_to: self()
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  @doc """

  Fetch the logs from a container

  * Returns the last 50 entries for stdout and stderr.

  """
  def logs(host, id) do
    {:ok, %HTTPoison.AsyncResponse{id: _id}} = HTTPoison.get host <> "/containers/#{id}/logs?stderr=1&stdout=1&timestamps=1&tail=50", %{}, stream_to: self()
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  def logs(id) do
    {:ok, %HTTPoison.AsyncResponse{id: _id}} = HTTP.stream "/containers/#{id}/logs?stderr=1&stdout=1&timestamps=1&tail=50", self()
    {:ok, stream_loop([]) |> Enum.reverse }
  end

  # TODO needs to be parsed correctly according to docker api
  defp stream_loop(acc, :done), do: acc
  defp stream_loop(acc) do
    receive do
      %HTTPoison.AsyncStatus{ id: _id, code: 200 } -> stream_loop(acc)
      %HTTPoison.AsyncHeaders{headers: _, id: _id} -> stream_loop(acc)
      %HTTPoison.AsyncChunk{id: _id, chunk: chk} ->
        case chk do
          <<_stream_type::8, 0, 0, 0, _size::32,rest::binary >> -> stream_loop([rest|acc])
          _ -> stream_loop(acc)
        end
      %HTTPoison.AsyncEnd{id: _id} ->
        stream_loop(acc, :done)
      %HTTPoison.Error{id: _id, reason: {:closed, _extra}} ->
        acc
    after
      5_000 ->
        IO.puts "Timeout waiting for stream"
        acc
    end
  end

  # WIP dont use
  def attach(host, id) do
    response = HTTP.post host <> "/containers/#{id}/attach?logs=1&stream=1&stdout=1&stdin=1"
    HTTP.stream("/containers/#{id}/attach", self())
    response
  end

  def attach(id) do
  DockerApi.HTTPStream.stream("/containers/#{id}/attach?logs=1&stream=1&stdout=1&stdin=1")

  end

end
