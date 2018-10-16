require 'net/ping'
require 'git'
require 'net/https'
require 'json'
require_relative 'error'

class GithubAPI
  include ResponseHandler
  attr_reader :github_account, :github_repos

  def initialize(account_name, page)
    @github_account = GithubAccount.new(account_name)
    @github_repos = GithubRepos.new(@github_account)
  end

  def clone_repositories
    github_repos.all.each { |repo| clone_repository(repo) }
  end

  def clone_repository(repo)
    git = Git.clone(repo['clone_url'], repo['name'], path: 'my_repositories')
    git.add_remote('originate', repo['clone_url'])
    puts repo['clone_url']
  end
end
