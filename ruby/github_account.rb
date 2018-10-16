require_relative 'error'
class GithubAccount
  include ResponseHandler

  attr_reader :account_name
  def initialize(account_name)
    @account_name = account_name
  end

  def url
    "https://api.github.com/users/#{account_name}"
  end

  def exists?
    response = parse_response(account_url)
    result = response['message'].nil?
    puts Error.user_missing_error unless result
    result
  end
end
