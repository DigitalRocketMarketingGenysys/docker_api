defmodule DockerApi.HTTPStream do
  require Logger
  @host Application.get_env(:docker_api, :host)
  @moduledoc """
    HTTP handler for all REST calls to the Docker API
  """

  def stream(url) do

    Logger.warn "Streaming: #{url}"


    Stream.resource(
      fn ->
        HTTPoison.get!(handle_request(url),  %{}, [stream_to: self(), async: :once])
      end,
 fn %HTTPoison.AsyncResponse{id: id}=resp->
   receive do
     %HTTPoison.AsyncStatus{id: ^id, code: code}->
       IO.inspect(code, label: "STATUS: ")
       HTTPoison.stream_next(resp)
       {[], resp}
     %HTTPoison.AsyncHeaders{id: ^id, headers: headers}->
       IO.inspect(headers, label: "HEADERS: ")
       HTTPoison.stream_next(resp)
       {[], resp}
     %HTTPoison.AsyncChunk{id: ^id, chunk: chunk}->
       HTTPoison.stream_next(resp)
       {[chunk], resp}
     %HTTPoison.AsyncEnd{id: ^id}->
       {:halt, resp}
   end
 end,
 fn %HTTPoison.AsyncResponse{id: id}=resp-> :hackney.stop_async(resp.id) end
    )

  end

  defp handle_request(url, opts) do
    Logger.warn "Handling Potential Request to be sent by Docker Engine API"
    host = Application.get_env(:docker_api, :host)
    with %{host: host, method: :unix} <- host do
      Logger.warn "Sending Request via: Unix"
      url = "http+unix://#{URI.encode_www_form(host)}#{url}?#{encode_query_params(opts)}" |> IO.inspect
    else
    %{host: host, method: :tcp} ->
      Logger.warn "Sending Request via: TCP"
      url
    end
  end

  defp handle_request(url) do
    Logger.warn "Handling Potential Request to be sent by Docker Engine API"
    IO.inspect url
    host = Application.get_env(:docker_api, :host)
    with %{host: host, method: :unix} <- host do
      Logger.warn "Sending Request via: Unix"
      url = "http+unix://#{URI.encode_www_form(host)}#{url}" |> IO.inspect
    else
    %{host: host, method: :tcp} ->
      Logger.warn "Sending Request via: TCP"
      url
    end
  end

  def query_params(args)  do
   Enum.map(Map.to_list(args), fn {k,v} -> encode_attribute(k, v) end)
   |> Enum.join("&")
  end

  def encode_query_params(opts) do
   URI.encode_query(opts)
  end

  def encode_attribute(k, v), do: "#{k}=#{encode_value(v)}"

  def encode_value(v), do: URI.encode_www_form("#{v}")

end
