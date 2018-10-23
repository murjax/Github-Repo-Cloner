class GithubRepos
  include ResponseHandler
  attr_reader :github_account

  def initialize(github_account)
    @github_account = github_account
  end

  def all
    number_of_pages.times.map do |index|
      repos_on_page(index + 1)
    end.flatten
  end

  private

  def repos_on_page(page)
    parse_response("#{github_account.url}/repos?page=#{page}")
  end

  def number_of_pages
    return [] unless github_account.exists?
    response = parse_response(github_account.url)
    (response['public_repos']/30.to_f).ceil
  end
end
