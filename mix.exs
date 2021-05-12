defmodule DockerApi.Mixfile do
  use Mix.Project

  def project do
    [app: :docker_api,
      version: "0.5.1",
      elixir: "~> 1.0",
      description: description(),
      package: package(),
      deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  def description do
    "Docker API for Elixir"
  end

  def package do
    [
      contributors: ["Bradley Smith"],
      licenses: ["The MIT License"],
      links: %{
        "GitHub" => "https://github.com/bradleyd/docker_api"
      }
    ]
  end

  defp deps do
    [
      {:ibrowse, "~> 4.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:httpoison, "~> 1.8"},
      {:mock, "~> 0.1", only: :test},
      {:poison, "~> 2.2.0"}
    ]
  end
end
