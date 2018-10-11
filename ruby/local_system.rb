module LocalSystem
  def clone_repository(repo)
    git = Git.clone(repo['clone_url'], repo['name'], path: 'my_repositories')
    git.add_remote('originate', repo['clone_url'])
    puts repo["clone_url"]
  end
end