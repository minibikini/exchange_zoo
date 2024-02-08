defmodule ExchangeZoo.MixProject do
  use Mix.Project

  def project do
    [
      app: :exchange_zoo,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExchangeZoo.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "release"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.16"},
      {:wind, github: "bfolkens/wind", ref: "30423e3a4f55cbe153b55391b545f87154e568c8"},
      {:jason, "~> 1.1"},
      {:ecto, "~> 3.9"},
    ]
  end
end
