defmodule DockerApi.HTTP do
  require Logger
  @host Application.get_env(:docker_api, :host)
  @moduledoc """
    HTTP handler for all REST calls to the Docker API
  """

  @doc """
  GET
        iex> DockerApi.HTTP.get("http://httpbin.org/get")
             {:ok, %{body: "foo", headers: _, status_code: 200} }
  """
  def get(url) do
    url
    |> handle_request
    |> HTTPoison.get
  end

  @doc """
  STREAM
        iex> DockerApi.HTTP.stream("http://httpbin.org/get")
             {:ok, %{body: "foo", headers: _, status_code: 200} }
  """
  def stream(url, agent) do
    url
    |> handle_request
    |> HTTPoison.get(%{"Accept" => "application/json"}, [recv_timeout: :infinity, stream_to: agent])
  end



  @doc """
  GET with query params
  * opts must be a map

        iex> DockerApi.HTTP.get("http://httpbin.org/get", %{foo: 1})
             {:ok, %{body: "foo", headers: _, status_code: 200} }
  """
  def get(url, opts) when is_map(opts) do
    Logger.warn "API: Getting Docker API Request"
    url
    |> handle_request(opts)
    |> HTTPoison.get

  end

  @doc """
  POST with optional payload
  * opts must be a map
  * payload is sent as JSON

        iex> DockerApi.HTTP.post("http://httpbin.org/get", %{foo: 1})
             {:ok, %{body: "foo", headers: _, status_code: 200} }
  """

  def post(url, opts) do
    url
    |> handle_request
    |> HTTPoison.post(Poison.encode!(opts), %{"Content-type" => "application/json"}, [recv_timeout: 500000])
  end

  def post_old(url, opts) do
    url
    |> handle_request(opts)
    |> HTTPoison.post(Poison.encode!(opts), %{"Content-type" => "application/json"}, [recv_timeout: 500000])
  end


  def post(url) do
    url
    |> handle_request
    |> HTTPoison.post(Poison.encode!(%{}), %{"Content-type" => "application/json"}, [recv_timeout: 500000])
  end
  def delete(url) do
    HTTPoison.delete(url)
  end

  def delete(url, opts) do
    url = url <> "?#{encode_query_params(opts)}"
    HTTPoison.delete(url)
  end

  defp handle_request(url, opts) do
    Logger.warn "Handling Potential Request to be sent by Docker Engine API with arity 2"
    host = Application.get_env(:docker_api, :host)
    with %{host: host, method: :unix} <- host do
      Logger.warn "Sending Request via: Unix"
      url = "http+unix://#{URI.encode_www_form(host)}#{url}?#{encode_query_params(opts)}"
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
      url = "http+unix://#{URI.encode_www_form(host)}#{url}"
    else
    %{host: host, method: :tcp} ->
      Logger.warn "Sending Request via: TCP"
      url
    end
  end

  def handle_response(resp = {:ok, %{status_code: 200, body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 201, body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 204, body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 301, body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 304, body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 404 , body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 400 , body: _body}}) do
    parse_response(resp)
  end

  def handle_response(resp = {:ok, %{status_code: 409 , body: _body}}) do
    {:ok, message, code} = parse_response(resp)
    if(!is_nil(message["message"]))do
    [[container_id | tail]] = Regex.scan(~r/[[:alnum:]]{64}/, message["message"])

    {:ok, %{"Id": container_id}, 409}
  else
    {:ok, %{"Id": "container_id"}, 409}
  end
  end

  def handle_response(resp = {:ok, %{status_code: 500, body: body}}) do
    Logger.warn "Handling error repsonse"
    IO.inspect body
    parse_response(resp)
  end

  def handle_response(resp = {:error, %HTTPoison.Error{id: _, reason: _reason}}) do
    parse_response(resp)
  end

  def parse_response({:error, %HTTPoison.Error{id: _, reason: reason}}) do
    { :error, reason, 500 }
  end

  def parse_response({:ok, resp = %HTTPoison.Response{body: "", headers: _headers, status_code: code}}) do
    {:ok, resp.body, code }
  end

  def parse_response({:ok, %HTTPoison.Response{body: body, headers: headers, status_code: code}}) do
    {"Content-Type", type} = List.keyfind(headers, "Content-Type", 0)
    case type do
      "text/plain; charset=utf-8" ->
        {:ok, body, code }
      "application/json" ->
        {:ok, Poison.decode!(body), code }
      "text/html; charset="<>charset ->
        # Added support for universal char set
        {:ok, body, code}
    end
  end

  def query_params(args)  do
   Enum.map(Map.to_list(args), fn {k,v} -> encode_attribute(k, v) end)
   |> Enum.join("&")
  end

  def encode_query_params(opts) do
   Plug.Conn.Query.encode(opts)
  end

  def encode_attribute(k, v), do: "#{k}=#{encode_value(v)}"

  def encode_value(v), do: URI.encode_www_form("#{v}")

end
