require_relative 'github_repo_handler.rb'

repositories = Repositories.new
repositories.clone_repositories
