import os
import git
import requests

from git import Repo
username = input("Please enter your Github account name: ")
response = requests.get("https://api.github.com/users/" + username + "/repos?per_page=100")
repositories =  response.json()
current_repos = os.listdir("./my_repositories/")

for repo in repositories:
    if repo["name"] not in current_repos:
        command = git.Git().clone(repo["clone_url"], "my_repositories/" + repo["name"], recursive=True)
        r = Repo("my_repositories/" + repo["name"])
        r.create_remote('originate', repo["clone_url"])
        print(repo["name"])