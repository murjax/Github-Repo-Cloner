require 'net/ping'
require 'git'
require 'net/https'
require 'json'
require_relative 'error'

class GithubAPI
  attr_reader :account_name, :page

  def initialize(account_name, page)
    @account_name, @page = account_name, page
  end

  def clone_repository(repo)
    git = Git.clone(repo['clone_url'], repo['name'], path: 'my_repositories')
    git.add_remote('originate', repo['clone_url'])
    puts repo['clone_url']
  end

  def number_of_pages
    return [] unless account_exists?
    response = parse_response(account_url)
    (response['public_repos']/30.to_f).ceil
  end

  def repos_on_page
    parse_response("#{account_url}/repos?page=#{page}")
  end

  private

  def parse_response(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def account_url
    "https://api.github.com/users/#{account_name}"
  end

  def account_exists?
    response = parse_response(account_url)
    result = response['message'].nil?
    puts Error.user_missing_error unless result
    result
  end
end
