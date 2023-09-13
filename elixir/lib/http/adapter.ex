defmodule GithubRepoCloner.Http.Adapter do
  @callback get(url :: String.t()) :: any
end
