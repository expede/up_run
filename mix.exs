defmodule UpRun.Mixfile do
  use Mix.Project

  def project do
    [
      app: :up_run,
      name: "Up & Running with Elixir",

      version: "1.0.0",
      elixir: "~> 1.4",

      deps: []
    ]
  end

  def application, do: [extra_applications: [:logger]]
end
