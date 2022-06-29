import os
import git
import requests

from git import Repo
username = input("Please enter your Github account name: ")
url = "https://api.github.com/users/" + username + "/repos?per_page=30"
response = requests.get(url)
repositories =  response.json()
try:
    current_repos = os.listdir("./my_repositories/")
except FileNotFoundError:
    current_repos = []

page = 1
while len(repositories) > 0:
    print('page ' + str(page))
    page += 1
    for repo in repositories:
        if repo["name"] not in current_repos:
            command = git.Git().clone(repo["clone_url"], "my_repositories/" + repo["name"], recursive=True)
            r = Repo("my_repositories/" + repo["name"])
            r.create_remote('originate', repo["clone_url"])
            print(repo["name"])
    new_response = requests.get(url + "&page=" + str(page))
    repositories = new_response.json()