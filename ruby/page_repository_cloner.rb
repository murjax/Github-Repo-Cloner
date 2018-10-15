class PageRepositoryCloner
  attr_reader :page_number, :github_api

  def initialize(page_number, github_api)
    @page_number, @github_api = page_number, github_api
  end

  def clone
    put_page_number
    github_api.repos_on_page.each { |repo| github_api.clone_repository(repo) }
  end

  private

  def put_page_number
    puts "api request ##{page_number}"
  end
end
