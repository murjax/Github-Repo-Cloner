defmodule GithubRepoCloner.Http.Client do
  use Tesla

  plug Tesla.Middleware.Headers, [{"User-Agent", "Elixir"}]
end
