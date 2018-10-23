require_relative 'github_repo_handler.rb'

def get_account_name
  puts 'Please enter your Github account name'
  STDOUT.flush
  STDIN.gets.chomp
end

github_api = GithubAPI.new(get_account_name)
github_api.clone_repositories
