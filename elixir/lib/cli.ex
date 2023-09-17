defmodule GithubRepoCloner.CLI do
  alias GithubRepoCloner.Cloner
  alias GithubRepoCloner.PageIterator

  def main(args \\ []) do
    username = List.first(args)
    PageIterator.repeat(&Cloner.clone_page/1, %{username: username, page: 1})
  end
end
