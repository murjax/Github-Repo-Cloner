require 'json'
require 'net/http'

class CloneHandler
  def initialize(username)
    @username = username
  end

  def call
    return unless clonable?

    Kernel.system(clone_command)
  end

  private

  attr_reader :username

  def info_uri
    URI("https://api.github.com/users/#{username}/repos")
  end

  def response
    @response ||= Net::HTTP.get_response(info_uri)
  end

  def response_body
    @response_body ||= begin
      return unless response.code == '200'

      JSON.parse(response.body)
    end
  end

  def clone_command
    @clone_command ||= response_body&.map { |info| "git clone #{info['clone_url']}" }&.join(' & ')
  end

  def clonable?
    !username.nil? &&
      username.length > 0 &&
      !clone_command.nil? &&
      !clone_command.empty?
  end
end
