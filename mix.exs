defmodule ExchangeZoo.MixProject do
  use Mix.Project

  def project do
    [
      app: :exchange_zoo,
      version: "0.1.0",
      elixir: "~> 1.13",
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
      {:castore, "~> 0.1.22"},
      {:finch, "~> 0.14"},
      # {:wind, "~> 0.0.1"},
      {:wind, path: "/Users/bfolkens/dev/bfolkens-github/wind"},
      {:jason, "~> 1.1"},
      {:ecto, "~> 3.9"},
    ]
  end
end
