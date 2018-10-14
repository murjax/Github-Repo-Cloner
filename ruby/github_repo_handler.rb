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

  def clone_repositories
    return unless connection? && user_exists?

    calulate_number_of_requests_to_send().times do |index|
      response_page_logic(index+1)  # starting at one because page=0 and page=1 are identical.
    end
  end

  def connection?
    result = Net::Ping::HTTP.new('https://api.github.com').ping?
    puts Error.network_error unless result
    result
  end

  def user_exists?
    result = github_user_info_request()['message'].nil?
    puts Error.user_missing_error unless result
    result
  end

  def response_page_logic(page_number)
    return unless repositories_exist?(page_number)

    puts "api request ##{page_number}" # leave this in here for visibility. If user exceeds api limit. need to know where they left off.
    github_repo_request(page_number).each { |repo| clone_repository(repo) }
  end

  def clone_repository(repo)
    git = Git.clone(repo['clone_url'], repo['name'], path: 'my_repositories')
    git.add_remote('originate', repo['clone_url'])
    puts repo["clone_url"]
  end

  def repositories_exist?(page)
    result = github_repo_request(page).count > 0
    puts Error.no_repositories_error unless result
    result
  end


  private def calulate_number_of_requests_to_send
    (github_user_info_request()['public_repos']/30.to_f).ceil
  end

  def github_user_info_request
    parse_response(github_url)
  end

  def github_repo_request(page)
    parse_response("#{github_url}/repos?page=#{page}")
  end

  def github_url
    "https://api.github.com/users/#{account_name}"
  end

  def parse_response(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
