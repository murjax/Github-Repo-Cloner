
module Github
    # **********         Api request logic.         **********
    def github_calulate_number_of_requests_to_send()
      (github_user_info_request()['public_repos']/30.to_f).ceil
    end
    def github_user_info_request()
      parse_response(github_url)
    end
    def github_repo_request(page) parse_response("#{github_url}/repos?page=#{page}") end
    def github_url() "https://api.github.com/users/#{account_name}" end

    def parse_response(url)
      uri = URI.parse(url)
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end

    # **********         Check connection logic   **********
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

    def repositories_exist?(page)
      result = github_repo_request(page).count > 0
      puts Error.no_repositories_error unless result
      result
    end

end
