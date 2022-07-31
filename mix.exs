defmodule Sse.MixProject do
  use Mix.Project

  def project do
    [
      app: :sse,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases(),
      test_paths: ["tests"],
      test_pattern: "*_test.exs"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SSE.Application, []},
      include_erts: true,
      include_executables_for: [:unix],
      cookie: Base.url_encode64(:crypto.strong_rand_bytes(40))
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.5"},
      {:plug_crypto, "~> 1.2"},
      {:cors_plug, "~> 3.0"},
      {:jason, "~>1.3"},
      {:uuid, ">= 2.0.4", [hex: :uuid_erl]},
      {:phoenix_pubsub, "~> 2.0"},
      {:poolboy, "~> 1.5"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.8", only: [:dev, :test]},
      {:x509, "~> 0.8.5", only: [:dev, :test]}
    ]
  end

  defp releases do
    [
      sse: [
        include_erts: true,
        include_executables_for: [:unix],
        applications: [
          sse: :permanent
        ]
      ]
    ]
  end
end
