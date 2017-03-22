require 'net/https'
require 'json'
require 'git'
require 'net/ping'

def get_account_name 
	puts "Please enter your Github account name"
	STDOUT.flush
	gets.chomp
end

def connection?
	Net::Ping::HTTP.new("https://api.github.com").ping?
end

def user_exists(account_name)
	JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}")))["message"].nil?
end

def clone_repositories(account_name)
	repositories = JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}/repos")))
	if repositories.count > 0
		repositories.each do |repo|
			git = Git.clone(repo["clone_url"], repo["name"], :path => "my_repositories")
			git.add_remote("originate", repo["clone_url"])
			puts repo["clone_url"]
		end
	else
		puts "No repositories found at this account"
	end
end