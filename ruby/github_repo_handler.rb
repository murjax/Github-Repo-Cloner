require 'net/https'
require 'json'
require 'git'
require 'net/ping'
require_relative 'error'

class GithubRepoHandler
  attr_reader :account_name

  def initialize
    @account_name = get_account_name
  end

  def get_account_name
    puts 'Please enter your Github account name'
    STDOUT.flush
    STDIN.gets.chomp
  end

  def connection?
    if Net::Ping::HTTP.new('https://api.github.com').ping?
      true
    else
      puts Error.network_error
      false
    end
  end

  def github_url
    "https://api.github.com/users/#{account_name}"
  end

  def github_response
    uri = URI.parse(github_url)
    response = Net::HTTP.get(uri)
    response_hash = JSON.parse(response)
  end

  def user_exists?
    if github_response['message'].nil?
      true
    else
      puts Error.user_missing_error
      false
    end
  end

  def repositories(page)
    uri = URI.parse("#{github_url}/repos?page=#{page}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def clone_repository(repo)
    git = Git.clone(repo['clone_url'], repo['name'], path: 'my_repositories')
    git.add_remote('originate', repo['clone_url'])
    puts repo["clone_url"]
  end

  def repositories_exist?(page)
    if repositories(page).count > 0
      true
    else
      puts Error.no_repositories_error
      false
    end
  end

  def clone_repositories
    return unless connection? && user_exists?
    number_of_pages.times do |index|
      page = index + 1 # starting at one because page=0 and page=1 are identical.
      next unless repositories_exist?(page)
      puts page # leave this in here for visibility. If user exceeds api limit. need to know where they left off.
      repositories(page).each { |repo| clone_repository(repo) }
    end
  end

  private

    def number_of_pages
      (github_response['public_repos']/30.to_f).ceil
    end
end
