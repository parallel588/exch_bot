defmodule ExchangeBot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exchange_bot,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExchangeBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5.0-rc.0"},
      {:cowboy, "~> 2.2"},
      {:tesla, "~> 0.10.0"},
      {:hackney, "~> 1.10"},
      {:poison, "~> 3.1"},
      {:mock, "~> 0.3.1", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
