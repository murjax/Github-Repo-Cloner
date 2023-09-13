ExUnit.start()
Mox.defmock(GithubRepoCloner.Http.Mock, for: GithubRepoCloner.Http.Adapter)
Application.put_env(:github_repo_cloner, :http_client, GithubRepoCloner.Http.Mock)
