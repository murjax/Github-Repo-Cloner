class GithubCloner
  attr_reader :account_name, :github_api

  def initialize
    @account_name = get_account_name
    @github_api = GithubAPI.new(@account_name)
  end

  def clone_repositories
    github_api.clone_repositories
  end

  private

  def get_account_name
    puts 'Please enter your Github account name'
    STDOUT.flush
    STDIN.gets.chomp
  end
end
