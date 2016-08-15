require 'net/https'
require 'json'
require 'git'
puts "Please enter your Github account name"
STDOUT.flush
account_name = gets.chomp
response = Net::HTTP.get(URI.parse("https://api.github.com/users/#{account_name}/repos"))
repositories = JSON.parse(response)

repositories.each do |repo|
	git = Git.clone(repo["clone_url"], repo["name"], :path => "my_repositories")
	git.add_remote("originate", repo["clone_url"])
	puts repo["clone_url"]
end


