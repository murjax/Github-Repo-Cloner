require 'net/https'
require 'json'
require 'net/ping'
module ResponseHandler
  def handle_request(url)
    response = submit_get_request(url)
    parse_json(response)
  end

  def submit_get_request(url)
    uri = parse_uri(url)
    Net::HTTP.get(uri)
  end

  def parse_uri(url)
    URI.parse(url)
  end

  def parse_json(json)
    JSON.parse(json)
  end
end
