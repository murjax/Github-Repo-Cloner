defmodule GithubRepoCloner.MixProject do
  use Mix.Project

  def project do
    [
      app: :github_repo_cloner,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, " ~> 1.7.0"},
      {:poison, "~> 5.0"},
      {:mox, "~> 1.0.2"}
    ]
  end

  defp escript do
    [main_module: GithubRepoCloner.CLI]
  end
end
