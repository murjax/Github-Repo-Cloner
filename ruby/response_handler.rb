module ResponseHandler
  def parse_response(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
