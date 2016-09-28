import os
import git
import requests

from git import Repo
username = raw_input("Please enter your Github account name: ")
response = requests.get("https://api.github.com/users/" + username + "/repos")
repositories =  response.json()

for repo in repositories:
	command = git.Git().clone(repo["clone_url"], "my_repositories/" + repo["name"], recursive=True)
	r = Repo("my_repositories/" + repo["name"])
	r.create_remote('originate', repo["clone_url"])
	print command