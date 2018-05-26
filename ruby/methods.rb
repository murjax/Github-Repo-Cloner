require 'net/https'
require 'json'
require 'git'
require 'net/ping'

def get_account_name
  puts "Please enter your Github account name"
  STDOUT.flush
  STDIN.gets.chomp
end

def connection?
  Net::Ping::HTTP.new("https://api.github.com").ping?
end

def github_url(account_name)
  "https://api.github.com/users/#{account_name}"
end

def user_exists?(account_name)
  if github_response(account_name)['message'].nil?
    true
  else
    puts user_missing_error
    false
  end
end

def github_response(account_name)
  uri = URI.parse(github_url(account_name))
  response = Net::HTTP.get(uri)
  response_hash = JSON.parse(response)
end

def repositories(account_name, page)
  uri = URI.parse("#{github_url(account_name)}/repos?page=#{page}")
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

def clone_repository(repo)
  git = Git.clone(repo["clone_url"], repo["name"], :path => "my_repositories")
  git.add_remote("originate", repo["clone_url"])
  puts repo["clone_url"]
end

def number_of_pages(account_name)
  (github_response(account_name)['public_repos']/30.to_f).ceil
end

def repositories_exist?(account_name, page)
  if repositories(account_name, page).count > 0
    true
  else
    puts no_repositories_error
    false
  end
end

def user_missing_error
  'Account does not exist'
end

def no_repositories_error
  'No repositories found at this account'
end

def clone_repositories(account_name)
  return unless user_exists?(account_name)
  number_of_pages(account_name).times do |index|
    page = index + 1 # starting at one because page=0 and page=1 are identical.
    next unless repositories_exist?(account_name, page)
    puts page # leave this in here for visibility. If user exceeds api limit. need to know where they left off.
    repositories(account_name, page).each { |repo| clone_repository(repo) }
  end
end
