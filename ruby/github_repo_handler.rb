require 'net/https'
require 'json'
require 'git'
require 'net/ping'
require_relative 'error'
require_relative 'github_api.rb'
  # github_calulate_number_of_requests_to_send, github_user_info_request, github_repo_request, github_url
  # connection?, user_exists?, repositories_exist?
require_relative 'local_system.rb'
  # clone_repository

class GithubRepoHandler
  attr_reader :account_name
  include Github
  include LocalSystem

  # **********         Object creation logic.             **********
  def initialize
    @account_name = get_account_name
  end

  def get_account_name
    puts 'Please enter your Github account name'
    STDOUT.flush
    STDIN.gets.chomp
  end

  # **********         Main clone repository logic.       **********
  def clone_repositories
    return unless connection? && user_exists?

    github_calulate_number_of_requests_to_send().times do |index|
      current_api_page_num = human_count(index)
      response_page_logic(current_api_page_num)
    end
  end

  def human_count(index)
    # online api's count start counting at 1.
    # human_count() is a count starting at 1 instead of 0.
    index+1
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

end
