defmodule DockerApi.Daemon do
  require Logger
  use GenServer
  alias DockerApi.HTTP

  @moduledoc """
    Docker Events Emitter Daemon

    Listen to the emitted docker events via GenServer.

    defmodule EventsProcessor do

    use GenServer


    def start_link(opts \\ []) do
      {:ok, pid} = GenServer.start_link(__MODULE__, :ok , opts)
    end

    def init(:ok) do
      {:ok, pid} = DockerApi.Daemon.start_link({:host, "/var/run/docker.sock"}, {:method, :unix}, {:agent, self()}, [])
      {:ok, %{daemon: pid}}
    end

    def handle_cast({:event, :ok}, state) do
        {:noreply, state}
    end

    def handle_cast({:event, event}, state) do
        handle_event(event)
        {:noreply, state}
    end

    def handle_event({:stop, actor}), do: Logger.warn "Received Stop Event from Docker"
    def handle_event({:start, actor}), do: Logger.warn "Received Start Event from Docker"
    def handle_event({:restart, actor}), do: Logger.warn "Received Restart Event from Docker"
    def handle_event({:kill, actor}), do: Logger.warn "Received Kill Event from Docker"


    def handle_info(msg, state) do
      Logger.warn "Received Message"

      {:noreply, state}
    end



    end


  """

  @doc """
  GET
        iex> DockerApi.HTTP.get("http://httpbin.org/get")
             {:ok, %{body: "foo", headers: _, status_code: 200} }
  """

  def start_link({:host, host}, {:method, method}, {:agent, agent}, opts \\ []) do
    Logger.info "Starting the Docker Engine Events Daemon"
    Application.put_env(:docker_api, :host, %{host: host, method: method}, [persistent: :true])
    {:ok, pid} = GenServer.start_link(__MODULE__, %{agent: agent}, opts)
    #GenServer.cast(agent, {:event, %{}})
    {:ok, pid}
  end

  def init(%{agent: agent}) do
    Logger.info "Initializing the Docker Engine Events Listener with Agent.."
    stream = HTTP.stream("/events", self())
    {:ok, %{stream: stream, agent: agent}}
  end

  def init(:ok) do
    Logger.info "Initializing the Docker Engine Events Listener.."
    stream = HTTP.stream("/events", self())
    {:ok, %{stream: stream}}
  end




  def handle_info(msg, state) do
    with %HTTPoison.AsyncChunk{chunk: chunk, id: id} <- msg do
      Logger.info "Received Message from Docker Engine"
      {:ok, event} = chunk |> Poison.decode

      if Map.has_key?(state, :agent) do
        DockerApi.Events.handle_event(event, state.agent)
      else
        DockerApi.Events.handle_event(event)
      end

    end

    {:noreply, state}
  end



end
