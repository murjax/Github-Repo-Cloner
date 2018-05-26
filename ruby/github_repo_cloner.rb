require_relative 'methods.rb'

if connection?
  clone_repositories(get_account_name)
else
  puts 'network error'
end
