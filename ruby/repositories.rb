class Repositories
  attr_reader :account_name

  def initialize
    @account_name = get_account_name
  end

  def clone_repositories
    github_api.number_of_pages.times do |index|
      page_number = human_count(index)
      PageRepositoryCloner.new(page_number, github_api).clone
    end
  end

  private

  def github_api
    @github_api ||= GithubAPI.new(account_name)
  end

  def get_account_name
    puts 'Please enter your Github account name'
    STDOUT.flush
    STDIN.gets.chomp
  end

  def human_count(index)
    index+1
  end
end
