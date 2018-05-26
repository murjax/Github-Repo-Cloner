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

def user_exists(account_name)
  JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}")))["message"].nil?
end

def clone_repositories(account_name)
  if user_exists(account_name)
    num_repos = JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}")))
    num_pages = (num_repos["public_repos"]/30.to_f).ceil
    i = 1 # starting at one because page=0 and page=1 are identical.
    while(i <= num_pages)
      repositories = JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}/repos?page=#{i}")))
      if repositories.count > 0
	puts i # leave this in here for visibility. If user exceeds api limit. need to know where they left off.
	repositories.each do |repo|
	  git = Git.clone(repo["clone_url"], repo["name"], :path => "my_repositories")
	  git.add_remote("originate", repo["clone_url"])
	  puts repo["clone_url"]
	end
      else
	puts "No repositories found at this account"
      end
      i+=1
    end
  else
    puts 'Account does not exist'
  end
end
