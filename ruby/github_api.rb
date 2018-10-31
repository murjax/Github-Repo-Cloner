require 'git'
require_relative 'github_account'
require_relative 'github_repos'
require_relative 'response_handler'

class GithubAPI
  include ResponseHandler
  attr_reader :github_account, :github_repos

  def initialize(account_name)
    @github_account = GithubAccount.new(account_name)
    @github_repos = GithubRepos.new(@github_account)
  end

  def clone_repositories
    github_repos.all.each { |repo| clone_repository(repo) }
  end

  private

  def clone_repository(repo)
    git = Git.clone(repo['clone_url'], repo['name'], path: 'my_repositories')
    git.add_remote('originate', repo['clone_url'])
    puts repo['clone_url']
  end
end
