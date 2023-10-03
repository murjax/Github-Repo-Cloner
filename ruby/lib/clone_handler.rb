require 'json'
require 'net/http'

class CloneHandler
  PER_PAGE = 30.freeze
  BASE_URL = 'https://api.github.com'.freeze
  NETWORK_ERROR_RESPONSE = { 'status' => '999', 'message' => 'Network error' }.freeze

  def self.get_username
    Kernel.puts 'Please enter your Github username'
    STDOUT.flush
    STDIN.gets.chomp
  end

  def initialize(username)
    @username = username
    @last_repo_info_request_failed = false
    @errors = []
  end

  def clone_all
    validate_clonable
    if errors?
      print_errors
      return false
    end

    Kernel.system(string_to_clone_all_repos_as_bash_job)
  end

  private

  attr_reader :username, :errors
  attr_accessor :last_repo_info_request_failed

  def string_to_clone_all_repos_as_bash_job
    clone_commands.flatten.join(' & ')
  end

  def clone_commands
    repo_info.map { |info| build_repo_clone_command(info) }
  end

  def repo_info
    @repo_info ||= begin
      repo_info = []

      page_count.times.each do |index|
        break if last_repo_info_request_failed

        info = repo_info_for_page(index + 1)
        check_for_repo_info_request_failure(info)
        repo_info.push(info)
      end

      repo_info.flatten.compact
    end
  end

  def build_repo_clone_command(info)
    return if info['clone_url'].nil?

    "git clone #{info['clone_url']} #{username}/#{info['name']}"
  end

  def repo_info_for_page(page)
    response = Net::HTTP.get_response(URI("#{user_info_url}/repos?page=#{page}"))
    info = JSON.parse(response.body)
    info.is_a?(Hash) ? info['status'] = response.code : info
    info
  rescue SocketError => _e
    [NETWORK_ERROR_RESPONSE]
  end

  def check_for_repo_info_request_failure(info)
    return unless info.is_a?(Hash) && info['status'].to_i >= 400

    self.last_repo_info_request_failed = true
  end

  def page_count
    (user_info&.dig('public_repos').to_i / PER_PAGE.to_f).ceil
  end

  def user_info
    @user_info ||= begin
      response = Net::HTTP.get_response(URI(user_info_url))
      user_info = JSON.parse(response.body)
      user_info['status'] = response.code
      user_info
    rescue SocketError => _e
      @user_info = NETWORK_ERROR_RESPONSE
    end
  end

  def user_info_url
    @user_info_url ||= "#{BASE_URL}/users/#{username}"
  end

  def errors?
    errors.length > 0
  end

  def validate_clonable
    validate_username
    validate_user_response
    validate_repo_presence
    validate_repo_responses
  end

  def validate_username
    return if !username.nil? && username.length > 0

    errors.push('No username provided')
  end

  def validate_user_response
    return if errors? || user_info.dig('status').to_i < 400

    errors.push(user_info.dig('message'))
  end

  def validate_repo_presence
    return if errors? || user_info.dig('public_repos').to_i > 0

    errors.push('No repositories found at this account')
  end

  def validate_repo_responses
    return if errors?

    repo_info.each do |info|
      next if info['status'].to_i < 400

      errors.push(info.dig('message'))
    end
  end

  def print_errors
    errors.each { |error| Kernel.puts(error) }
  end
end
