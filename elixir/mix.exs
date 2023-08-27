defmodule GithubRepoClonerElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :github_repo_cloner_elixir,
      version: "0.1.0",
      elixir: "~> 1.5",
      escript: escript(),
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpotion],
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [
      main_module: GithubRepoCloner
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"}
    ]
  end
end
