import Config

config :github_repo_cloner, :http_client, GithubRepoCloner.Http.Mock
config :github_repo_cloner, :system, GithubRepoCloner.MockSystem
