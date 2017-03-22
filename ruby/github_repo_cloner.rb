require 'net/https'
require 'json'
require 'git'
require 'net/ping'
puts "Please enter your Github account name"
STDOUT.flush
account_name = gets.chomp

if Net::Ping::HTTP.new("http://www.google.com/index.html").ping?
	user_response = Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}"))
	repo_response = Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}/repos"))
	repositories = JSON.parse(user_response)

	if repositories["message"]
		puts "Account does not exist"
	else
		repositories = JSON.parse(repo_response)

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


