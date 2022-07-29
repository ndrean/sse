defmodule Sse.MixProject do
  use Mix.Project

  def project do
    [
      app: :sse,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SSE.Application, []},
      include_erts: true,
      include_executables_for: [:unix]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.5"},
      {:plug_crypto, "~> 1.2"},
      {:cors_plug, "~> 3.0"},
      {:jason, "~>1.3"},
      {:uuid, ">= 2.0.4", [hex: :uuid_erl]},
      {:phoenix_pubsub, "~> 2.0"}
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
