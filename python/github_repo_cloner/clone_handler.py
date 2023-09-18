import requests
import subprocess

def clone(username):
    if username in (None, ''):
        return

    repositories = get_repositories(username)
    if len(repositories) == 0:
        return

    commands = map(lambda repo_info: create_command(repo_info, username), repositories)
    final_command = ' & '.join(commands)
    subprocess.run(final_command, shell=True, check=False)

def create_command(repo_info, username):
    return f'git clone {repo_info["clone_url"]} {username}/{repo_info["name"]}'

def get_repositories(username):
    response = requests.get("https://api.github.com/users/" + username + "/repos")
    if response.status_code != 200:
        return []

    return response.json()
