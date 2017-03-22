require_relative 'methods.rb'
account_name = get_account_name
if connection?
	if user_exists(account_name)
		clone_repositories(account_name)
	else
		puts "Account does not exist"
	end
else
	puts "network error"
end


