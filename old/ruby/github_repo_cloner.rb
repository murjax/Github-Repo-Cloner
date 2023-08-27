require_relative 'github_repo_handler.rb'

handler = GithubRepoHandler.new
handler.clone_repositories
