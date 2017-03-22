require 'net/https'
require 'json'
require 'git'
require 'net/ping'

puts "Please enter your Github account name"
STDOUT.flush
account_name = gets.chomp

if Net::Ping::HTTP.new("https://api.github.com").ping?
	user_response = JSON.parse(Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}")))
	if user_response["message"]
		puts "Account does not exist"
	else
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
else 
	puts "network error"
end


