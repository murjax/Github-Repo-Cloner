defmodule GithubRepoCloner.CLI do
  def main(args \\ []) do
    args
    |> List.first
    |> GithubRepoCloner.Cloner.clone
  end
end
